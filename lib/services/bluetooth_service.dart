import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:permission_handler/permission_handler.dart';
import '../models/models.dart';
import 'bluetooth_exceptions.dart';

/// 蓝牙服务类
class CharacteristicDataEvent {
  final String characteristicUuid;
  final SensorData data;

  CharacteristicDataEvent({
    required this.characteristicUuid,
    required this.data,
  });
}

const String _unknownDeviceName = 'Unknown Device';




class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  fbp.BluetoothDevice? _connectedDevice;
  final Map<String, fbp.BluetoothCharacteristic> _characteristics = {};
  final Map<String, StreamSubscription<List<int>>> _notificationSubscriptions =
      {};
  StreamSubscription<fbp.BluetoothConnectionState>? _deviceStateSubscription;
  Timer? _rssiTimer;

  // 数据流控制器
  final StreamController<CharacteristicDataEvent>
  _characteristicDataController =
      StreamController<CharacteristicDataEvent>.broadcast();
  final StreamController<SensorData> _sensorDataController =
      StreamController<SensorData>.broadcast();
  final StreamController<DeviceInfo> _deviceDiscoveryController =
      StreamController<DeviceInfo>.broadcast();
  final StreamController<BluetoothConnectionState> _connectionStateController =
      StreamController<BluetoothConnectionState>.broadcast();
  final StreamController<int> _rssiController =
      StreamController<int>.broadcast();

  // 公开的数据流
  Stream<CharacteristicDataEvent> get characteristicDataStream =>
      _characteristicDataController.stream;
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
          name: device.platformName.isNotEmpty ? device.platformName : _unknownDeviceName,
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
                  : _unknownDeviceName,
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
      throw BluetoothServiceException(
        BluetoothErrorCode.scanFailed,
        cause: e,
      );
    }

    _sortDevicesForPresentation(devices);
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
            unawaited(_cancelAllNotifications());
            _stopRssiMonitoring();
            _connectedDevice = null;
            break;
          default:
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
  Future<Map<String, bool>> setupDataNotification({
    String? serviceUuid,
    String? characteristicUuid,
    List<String>? characteristicUuids,
  }) async {
    final List<String> requestedUuids = <String>[
      if (characteristicUuids != null) ...characteristicUuids,
      if ((characteristicUuids == null || characteristicUuids.isEmpty) &&
          characteristicUuid != null)
        characteristicUuid,
    ].where((uuid) => uuid.trim().isNotEmpty).toList();

    if (requestedUuids.isEmpty) {
      return const {};
    }

    if (_connectedDevice == null || !_connectedDevice!.isConnected) {
      return {for (final uuid in requestedUuids) uuid: false};
    }

    try {
      final Map<String, String> normalizedToOriginal = {};
      for (final String uuid in requestedUuids) {
        final String normalized = _normalizeUuid(uuid);
        normalizedToOriginal.putIfAbsent(normalized, () => uuid);
      }

      final List<fbp.BluetoothService> services = await _connectedDevice!
          .discoverServices();
      final String? normalizedServiceUuid = serviceUuid?.trim().toLowerCase();
      final Map<String, bool> results = {};

      for (final MapEntry<String, String> entry
          in normalizedToOriginal.entries) {
        final String normalizedUuid = entry.key;
        final String originalUuid = entry.value;

        debugPrint(
          '[BluetoothService] Attempting to subscribe -> $originalUuid',
        );

        final fbp.BluetoothCharacteristic? characteristic = _findCharacteristic(
          services,
          normalizedUuid,
          normalizedServiceUuid,
        );

        if (characteristic == null) {
          debugPrint(
            '[BluetoothService] Characteristic not found for $originalUuid',
          );
          results[originalUuid] = false;
          continue;
        }

        final bool success = await _startListeningToCharacteristic(
          normalizedUuid: normalizedUuid,
          characteristic: characteristic,
        );
        results[originalUuid] = success;
      }

      return results;
    } catch (e) {
      debugPrint('[BluetoothService] setupDataNotification error: $e');
      return {for (final uuid in requestedUuids) uuid: false};
    }
  }

  Future<void> disconnect() async {
    try {
      _connectionStateController.add(BluetoothConnectionState.disconnecting);

      await _cancelAllNotifications();
      await _deviceStateSubscription?.cancel();
      _deviceStateSubscription = null;
      _stopRssiMonitoring();

      await _connectedDevice?.disconnect();
      _connectedDevice = null;

      _connectionStateController.add(BluetoothConnectionState.disconnected);
    } catch (e) {
      _connectionStateController.add(BluetoothConnectionState.error);
      throw BluetoothServiceException(
        BluetoothErrorCode.disconnectionFailed,
        cause: e,
      );
    }
  }

  Future<bool> _startListeningToCharacteristic({
    required String normalizedUuid,
    required fbp.BluetoothCharacteristic characteristic,
    bool isRetry = false,
  }) async {
    try {
      await _notificationSubscriptions[normalizedUuid]?.cancel();
      _notificationSubscriptions.remove(normalizedUuid);

      await characteristic.setNotifyValue(true);
      final StreamSubscription<List<int>>
      subscription = characteristic.lastValueStream.listen(
        (List<int> data) => _handleIncomingData(normalizedUuid, data),
        onError: (Object error) {
          debugPrint(
            '[BluetoothService] Notification stream error ($normalizedUuid): $error',
          );
        },
        onDone: () {
          debugPrint(
            '[BluetoothService] Notification stream closed ($normalizedUuid)',
          );
        },
      );

      _notificationSubscriptions[normalizedUuid] = subscription;
      _characteristics[normalizedUuid] = characteristic;

      debugPrint('[BluetoothService] Notification started -> $normalizedUuid');
      return true;
    } catch (e) {
      debugPrint(
        '[BluetoothService] Notification failed for $normalizedUuid: $e',
      );
      if (!isRetry) {
        debugPrint(
          '[BluetoothService] Retrying notification for $normalizedUuid in 1s',
        );
        await Future.delayed(const Duration(seconds: 1));
        return _startListeningToCharacteristic(
          normalizedUuid: normalizedUuid,
          characteristic: characteristic,
          isRetry: true,
        );
      }

      debugPrint(
        '[BluetoothService] Notification retry failed for $normalizedUuid: $e',
      );
      _notificationSubscriptions.remove(normalizedUuid);
      _characteristics.remove(normalizedUuid);
      return false;
    }
  }

  void _handleIncomingData(String normalizedUuid, List<int> data) {
    try {
      if (data.length != 4) {
        return;
      }

      final SensorData sensorData = SensorData.fromBinary(data);
      _sensorDataController.add(sensorData);
      _characteristicDataController.add(
        CharacteristicDataEvent(
          characteristicUuid: normalizedUuid,
          data: sensorData,
        ),
      );
    } catch (e) {
      debugPrint(
        '[BluetoothService] Failed to parse data for $normalizedUuid: $e',
      );
    }
  }

  fbp.BluetoothCharacteristic? _findCharacteristic(
    List<fbp.BluetoothService> services,
    String normalizedCharacteristicUuid,
    String? normalizedServiceUuid,
  ) {
    for (final fbp.BluetoothService service in services) {
      if (normalizedServiceUuid != null &&
          service.uuid.toString().toLowerCase() != normalizedServiceUuid) {
        continue;
      }

      for (final fbp.BluetoothCharacteristic characteristic
          in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase() ==
            normalizedCharacteristicUuid) {
          return characteristic;
        }
      }
    }

    return null;
  }


  void sortDiscoveredDevices(List<DeviceInfo> devices) {
    _sortDevicesForPresentation(devices);
  }

  void _sortDevicesForPresentation(List<DeviceInfo> devices) {
    devices.sort((DeviceInfo a, DeviceInfo b) {
      final bool aHasName = _hasMeaningfulName(a.name);
      final bool bHasName = _hasMeaningfulName(b.name);
      if (aHasName != bHasName) {
        return aHasName ? -1 : 1;
      }

      final int aRssi = a.rssi ?? -1000;
      final int bRssi = b.rssi ?? -1000;
      final int rssiCompare = bRssi.compareTo(aRssi);
      if (rssiCompare != 0) {
        return rssiCompare;
      }

      return a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase());
    });
  }

  bool _hasMeaningfulName(String name) {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return false;
    }
    final String lower = trimmed.toLowerCase();
    if (lower == _unknownDeviceName.toLowerCase()) {
      return false;
    }
    if (lower.startsWith('unknown')) {
      return false;
    }
    if (trimmed.startsWith('未知')) {
      return false;
    }
    return true;
  }

  String _normalizeUuid(String uuid) => uuid.trim().toLowerCase();

  Future<void> _cancelAllNotifications() async {
    if (_notificationSubscriptions.isEmpty && _characteristics.isEmpty) {
      return;
    }

    await stopDataNotification();
  }

  Future<Map<String, bool>> stopDataNotification({
    List<String>? characteristicUuids,
  }) async {
    final List<String> targets =
        (characteristicUuids != null && characteristicUuids.isNotEmpty)
        ? characteristicUuids.map(_normalizeUuid).toList()
        : _notificationSubscriptions.keys.toList();

    final Map<String, bool> results = {};

    for (final String target in targets) {
      final String normalizedUuid = _normalizeUuid(target);
      final StreamSubscription<List<int>>? subscription =
          _notificationSubscriptions.remove(normalizedUuid);
      bool cancelled = false;
      if (subscription != null) {
        await subscription.cancel();
        cancelled = true;
      }

      final fbp.BluetoothCharacteristic? characteristic = _characteristics
          .remove(normalizedUuid);
      if (characteristic != null) {
        try {
          await characteristic.setNotifyValue(false);
        } catch (e) {
          debugPrint(
            '[BluetoothService] Failed to stop notification for $normalizedUuid: $e',
          );
        }
      }

      results[target] = cancelled;
    }

    return results;
  }

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
  /// 发送数据到设备
  Future<void> sendData(String data, {String? characteristicUuid}) async {
    if (_connectedDevice?.isConnected != true) {
      throw BluetoothServiceException(BluetoothErrorCode.deviceNotConnected);
    }

    fbp.BluetoothCharacteristic? targetCharacteristic;

    if (characteristicUuid != null) {
      targetCharacteristic =
          _characteristics[_normalizeUuid(characteristicUuid)];
    } else if (_characteristics.isNotEmpty) {
      targetCharacteristic = _characteristics.values.first;
    }

    if (targetCharacteristic == null) {
      throw BluetoothServiceException(
        BluetoothErrorCode.writeCharacteristicNotFound,
      );
    }

    await targetCharacteristic.write(utf8.encode(data));
  }

  /// 检查连接状态
  bool get isConnected => _connectedDevice?.isConnected == true;

  /// 获取连接的设备地址
  String? get connectedDeviceAddress => _connectedDevice?.remoteId.str;

  /// 释放资源
  void dispose() {
    for (final StreamSubscription<List<int>> subscription
        in _notificationSubscriptions.values) {
      subscription.cancel();
    }
    _notificationSubscriptions.clear();
    _characteristics.clear();

    _deviceStateSubscription?.cancel();
    _deviceStateSubscription = null;
    _stopRssiMonitoring();

    _connectedDevice?.disconnect();

    _characteristicDataController.close();
    _sensorDataController.close();
    _deviceDiscoveryController.close();
    _connectionStateController.close();
    _rssiController.close();
  }
}
