import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:permission_handler/permission_handler.dart';
import '../models/models.dart';

/// 蓝牙服务类
class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  fbp.BluetoothDevice? _connectedDevice;
  fbp.BluetoothCharacteristic? _characteristic;
  StreamSubscription<List<int>>? _dataSubscription;
  StreamSubscription<fbp.BluetoothConnectionState>? _deviceStateSubscription;
  Timer? _rssiTimer;

  // 数据流控制器
  final StreamController<SensorData> _sensorDataController =
      StreamController<SensorData>.broadcast();
  final StreamController<DeviceInfo> _deviceDiscoveryController =
      StreamController<DeviceInfo>.broadcast();
  final StreamController<BluetoothConnectionState> _connectionStateController =
      StreamController<BluetoothConnectionState>.broadcast();
  final StreamController<int> _rssiController =
      StreamController<int>.broadcast();

  // 公开的数据流
  Stream<SensorData> get sensorDataStream => _sensorDataController.stream;
  Stream<DeviceInfo> get deviceDiscoveryStream =>
      _deviceDiscoveryController.stream;
  Stream<BluetoothConnectionState> get connectionStateStream =>
      _connectionStateController.stream;
  Stream<int> get rssiStream => _rssiController.stream;

  /// 检查蓝牙权限
  Future<bool> checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  /// 检查蓝牙是否启用
  Future<bool> isBluetoothEnabled() async {
    try {
      fbp.BluetoothAdapterState state =
          await fbp.FlutterBluePlus.adapterState.first;
      return state == fbp.BluetoothAdapterState.on;
    } catch (e) {
      return false;
    }
  }

  /// 启用蓝牙
  Future<bool> enableBluetooth() async {
    try {
      await fbp.FlutterBluePlus.turnOn();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 扫描BLE 5.0设备
  Future<List<DeviceInfo>> scanDevices({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    List<DeviceInfo> devices = [];

    try {
      // 获取已连接的设备
      List<fbp.BluetoothDevice> connectedDevices =
          fbp.FlutterBluePlus.connectedDevices;
      for (fbp.BluetoothDevice device in connectedDevices) {
        DeviceInfo deviceInfo = DeviceInfo(
          name: device.platformName.isNotEmpty ? device.platformName : '未知设备',
          address: device.remoteId.str,
          isConnected: true,
        );
        devices.add(deviceInfo);
        _deviceDiscoveryController.add(deviceInfo);
      }

      // 开始扫描新设备 - 使用BLE 5.0优化参数
      await fbp.FlutterBluePlus.startScan(
        timeout: timeout,
        androidUsesFineLocation: true, // 使用精确位置以获得更好的BLE 5.0性能
      );

      // 监听扫描结果
      StreamSubscription<List<fbp.ScanResult>>? scanSubscription;
      scanSubscription = fbp.FlutterBluePlus.scanResults.listen((
        List<fbp.ScanResult> results,
      ) {
        for (fbp.ScanResult result in results) {
          // 过滤BLE设备（通常RSSI > -100dBm表示较近距离）
          if (result.rssi > -100) {
            DeviceInfo deviceInfo = DeviceInfo(
              name: result.device.platformName.isNotEmpty
                  ? result.device.platformName
                  : result.advertisementData.advName.isNotEmpty
                  ? result.advertisementData.advName
                  : '未知设备',
              address: result.device.remoteId.str,
              rssi: result.rssi,
              isConnected: false,
            );

            // 避免重复添加
            if (!devices.any((d) => d.address == deviceInfo.address)) {
              devices.add(deviceInfo);
              _deviceDiscoveryController.add(deviceInfo);
            }
          }
        }
      });

      // 等待扫描完成
      await Future.delayed(timeout);
      await scanSubscription.cancel();
      await fbp.FlutterBluePlus.stopScan();
    } catch (e) {
      throw Exception('扫描BLE设备失败: $e');
    }

    return devices;
  }

  /// 连接到设备 (仅建立BLE连接)
  Future<bool> connectToDevice(String address) async {
    try {
      _connectionStateController.add(BluetoothConnectionState.connecting);

      // 查找设备
      fbp.BluetoothDevice? device;
      List<fbp.ScanResult> scanResults = fbp.FlutterBluePlus.lastScanResults;
      for (fbp.ScanResult result in scanResults) {
        if (result.device.remoteId.str == address) {
          device = result.device;
          break;
        }
      }

      if (device == null) {
        _connectionStateController.add(BluetoothConnectionState.error);
        return false;
      }

      // 连接设备
      await device.connect();
      _connectedDevice = device;

      // 监听连接状态变化
      _deviceStateSubscription?.cancel();
      _deviceStateSubscription = device.connectionState.listen((state) {
        switch (state) {
          case fbp.BluetoothConnectionState.connected:
            _connectionStateController.add(BluetoothConnectionState.connected);
            _startRssiMonitoring();
            break;
          case fbp.BluetoothConnectionState.disconnected:
            _connectionStateController.add(
              BluetoothConnectionState.disconnected,
            );
            _connectedDevice = null;
            _characteristic = null;
            _stopRssiMonitoring();
            break;
          default:
            // 处理其他状态（如connecting等已弃用状态）
            break;
        }
      });

      _connectionStateController.add(BluetoothConnectionState.connected);
      _startRssiMonitoring();
      return true;
    } catch (e) {
      _connectionStateController.add(BluetoothConnectionState.error);
      return false;
    }
  }

  /// 匹配UUID并启动数据监听
  Future<bool> setupDataNotification({
    String? serviceUuid,
    String? characteristicUuid,
  }) async {
    if (_connectedDevice == null || !_connectedDevice!.isConnected) {
      return false;
    }

    try {
      // 发现服务
      List<fbp.BluetoothService> services = await _connectedDevice!
          .discoverServices();

      // 查找指定的特征值
      if (serviceUuid != null && characteristicUuid != null) {
        // 使用指定的UUID查找
        for (fbp.BluetoothService service in services) {
          if (service.uuid.toString().toLowerCase() ==
              serviceUuid.toLowerCase()) {
            for (fbp.BluetoothCharacteristic characteristic
                in service.characteristics) {
              if (characteristic.uuid.toString().toLowerCase() ==
                  characteristicUuid.toLowerCase()) {
                _characteristic = characteristic;
                break;
              }
            }
            break;
          }
        }
      }

      if (_characteristic != null) {
        _startListeningToData();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// 断开连接
  Future<void> disconnect() async {
    try {
      _connectionStateController.add(BluetoothConnectionState.disconnecting);

      await _dataSubscription?.cancel();
      _dataSubscription = null;

      await _connectedDevice?.disconnect();
      _connectedDevice = null;
      _characteristic = null;

      _connectionStateController.add(BluetoothConnectionState.disconnected);
    } catch (e) {
      _connectionStateController.add(BluetoothConnectionState.error);
      throw Exception('断开连接失败: $e');
    }
  }

  /// 开始监听数据
  void _startListeningToData() async {
    if (_characteristic == null) return;

    try {
      // 启用通知
      await _characteristic!.setNotifyValue(true);

      _dataSubscription = _characteristic!.lastValueStream.listen(
        (List<int> data) {
          try {
            _parseAndEmitBinaryData(data);
          } catch (e) {
            // 数据解析错误，忽略
          }
        },
        onError: (error) {
          _connectionStateController.add(BluetoothConnectionState.error);
        },
        onDone: () {
          _connectionStateController.add(BluetoothConnectionState.disconnected);
        },
      );
    } catch (e) {
      _connectionStateController.add(BluetoothConnectionState.error);
    }
  }

  /// 停止数据监听 (保持连接)
  Future<bool> stopDataNotification() async {
    try {
      // 取消数据订阅
      await _dataSubscription?.cancel();
      _dataSubscription = null;

      // 禁用通知 (保持连接)
      if (_characteristic != null) {
        await _characteristic!.setNotifyValue(false);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 开始RSSI监控
  void _startRssiMonitoring() {
    _stopRssiMonitoring(); // 先停止之前的监控

    if (_connectedDevice != null) {
      _rssiTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        try {
          if (_connectedDevice != null && _connectedDevice!.isConnected) {
            final rssi = await _connectedDevice!.readRssi();
            // 发送RSSI数据到流中
            _rssiController.add(rssi);
          }
        } catch (e) {
          // RSSI读取失败，忽略
        }
      });
    }
  }

  /// 停止RSSI监控
  void _stopRssiMonitoring() {
    _rssiTimer?.cancel();
    _rssiTimer = null;
  }

  /// 解析并发送二进制传感器数据
  void _parseAndEmitBinaryData(List<int> data) {
    try {
      // ESP32发送的是4字节float数据
      if (data.length == 4) {
        // 使用工厂方法解析二进制数据
        SensorData sensorData = SensorData.fromBinary(data);
        _sensorDataController.add(sensorData);
      }
    } catch (e) {
      // 数据解析错误，静默忽略
    }
  }

  /// 发送数据到设备
  Future<void> sendData(String data) async {
    if (_characteristic != null && _connectedDevice?.isConnected == true) {
      await _characteristic!.write(utf8.encode(data));
    } else {
      throw Exception('设备未连接');
    }
  }

  /// 检查连接状态
  bool get isConnected => _connectedDevice?.isConnected == true;

  /// 获取连接的设备地址
  String? get connectedDeviceAddress => _connectedDevice?.remoteId.str;

  /// 释放资源
  void dispose() {
    _dataSubscription?.cancel();
    _connectedDevice?.disconnect();
    _sensorDataController.close();
    _deviceDiscoveryController.close();
    _connectionStateController.close();
  }
}
