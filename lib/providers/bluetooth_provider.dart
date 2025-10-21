import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

/// 蓝牙状态提供者
class BluetoothProvider extends ChangeNotifier {
  final BluetoothService _bluetoothService = BluetoothService();

  BluetoothState _state = BluetoothState();
  StreamSubscription<DeviceInfo>? _deviceDiscoverySubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;
  StreamSubscription<int>? _rssiSubscription;
  StreamSubscription<CharacteristicDataEvent>? _characteristicDataSubscription;

  final Map<String, SensorData> _latestSensorDataByUuid = {};
  final Map<String, List<SensorData>> _sensorDataHistoryByUuid = {};
  final Map<String, bool> _activeNotifications = {};

  static const int _historyLimit = 200;

  BluetoothState get state => _state;

  // 便捷访问器
  bool get isBluetoothEnabled => _state.isBluetoothEnabled;
  bool get isConnected => _state.isConnected;
  bool get isConnecting => _state.isConnecting;
  bool get isScanning => _state.isScanning;
  DeviceInfo? get connectedDevice => _state.connectedDevice;
  List<DeviceInfo> get discoveredDevices => _state.discoveredDevices;
  String? get errorMessage => _state.errorMessage;
  Map<String, SensorData> get latestSensorDataByUuid =>
      Map.unmodifiable(_latestSensorDataByUuid);
  Map<String, bool> get notificationStatus =>
      Map.unmodifiable(_activeNotifications);
  List<SensorData> getSensorDataHistory(String uuid) =>
      List.unmodifiable(_sensorDataHistoryByUuid[uuid] ?? const []);
  Set<String> get activeNotificationUuids => _activeNotifications.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toSet();

  BluetoothProvider() {
    _initializeBluetoothService();
  }

  /// 初始化蓝牙服务
  void _initializeBluetoothService() {
    // 监听设备发现
    _deviceDiscoverySubscription = _bluetoothService.deviceDiscoveryStream
        .listen((DeviceInfo device) {
          _addDiscoveredDevice(device);
        });

    // 监听连接状态变化
    _connectionStateSubscription = _bluetoothService.connectionStateStream
        .listen((BluetoothConnectionState connectionState) {
          _updateConnectionState(connectionState);
        });

    // 监听RSSI变化
    _rssiSubscription = _bluetoothService.rssiStream.listen((rssi) {
      _updateRssi(rssi);
    });

    _characteristicDataSubscription = _bluetoothService.characteristicDataStream
        .listen(_handleCharacteristicData);

    // 检查初始蓝牙状态
    _checkBluetoothStatus();
  }

  /// 检查蓝牙状态
  Future<void> _checkBluetoothStatus() async {
    try {
      final isEnabled = await _bluetoothService.isBluetoothEnabled();
      _state = _state.copyWith(isBluetoothEnabled: isEnabled);
      notifyListeners();
    } catch (e) {
      _setError('检查蓝牙状态失败: $e');
    }
  }

  /// 检查并请求权限
  Future<bool> checkPermissions() async {
    try {
      return await _bluetoothService.checkPermissions();
    } catch (e) {
      _setError('权限检查失败: $e');
      return false;
    }
  }

  /// 启用蓝牙
  Future<bool> enableBluetooth() async {
    try {
      final result = await _bluetoothService.enableBluetooth();
      _state = _state.copyWith(isBluetoothEnabled: result);
      notifyListeners();
      return result;
    } catch (e) {
      _setError('启用蓝牙失败: $e');
      return false;
    }
  }

  /// 开始扫描设备
  Future<void> startScan() async {
    if (_state.isScanning) return;

    try {
      _state = _state.copyWith(
        scanState: BluetoothScanState.scanning,
        discoveredDevices: [], // 清空之前的设备列表
        clearError: true,
      );
      notifyListeners();

      await _bluetoothService.scanDevices();

      _state = _state.copyWith(scanState: BluetoothScanState.stopped);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        scanState: BluetoothScanState.error,
        errorMessage: '扫描设备失败: $e',
      );
      notifyListeners();
    }
  }

  /// 停止扫描
  void stopScan() {
    if (!_state.isScanning) return;

    _state = _state.copyWith(scanState: BluetoothScanState.stopped);
    notifyListeners();
  }

  /// 连接到设备
  Future<void> connectToDevice(DeviceInfo device) async {
    if (_state.isConnecting || _state.isConnected) return;

    try {
      _state = _state.copyWith(
        connectionState: BluetoothConnectionState.connecting,
        clearError: true,
      );
      notifyListeners();

      // 步骤1: 建立BLE连接
      final success = await _bluetoothService.connectToDevice(device.address);

      if (success) {
        final connectedDevice = device.copyWith(
          isConnected: true,
          lastConnected: DateTime.now(),
        );

        _state = _state.copyWith(
          connectionState: BluetoothConnectionState.connected,
          connectedDevice: connectedDevice,
        );
        _clearNotificationState();
      } else {
        _state = _state.copyWith(
          connectionState: BluetoothConnectionState.error,
          errorMessage: '连接失败',
        );
      }
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        connectionState: BluetoothConnectionState.error,
        errorMessage: '连接设备失败: $e',
      );
      notifyListeners();
    }
  }

  /// 设置数据通知 (支持多个UUID并行订阅)
  Future<bool> setupDataNotification({
    String? serviceUuid,
    String? characteristicUuid,
    List<String>? characteristicUuids,
  }) async {
    if (!_state.isConnected) return false;

    final List<String>? requestedUuids =
        characteristicUuids ??
        (characteristicUuid != null ? <String>[characteristicUuid] : null);
    if (requestedUuids == null || requestedUuids.isEmpty) {
      _setError('未提供有效的特征UUID');
      return false;
    }

    try {
      final results = await _bluetoothService.setupDataNotification(
        serviceUuid: serviceUuid,
        characteristicUuids: requestedUuids,
      );

      bool anySuccess = false;
      for (final MapEntry<String, bool> entry in results.entries) {
        final String normalizedUuid = _normalizeUuid(entry.key);
        _activeNotifications[normalizedUuid] = entry.value;
        if (entry.value) {
          _sensorDataHistoryByUuid.putIfAbsent(
            normalizedUuid,
            () => <SensorData>[],
          );
          anySuccess = true;
        } else {
          _latestSensorDataByUuid.remove(normalizedUuid);
          _sensorDataHistoryByUuid.remove(normalizedUuid);
        }
      }

      notifyListeners();
      return anySuccess;
    } catch (e) {
      _state = _state.copyWith(errorMessage: '设置数据通知失败: $e');
      notifyListeners();
      return false;
    }
  }

  /// 停止数据通知 (保持连接)
  Future<bool> stopDataNotification({
    List<String>? characteristicUuids,
    String? characteristicUuid,
  }) async {
    if (!_state.isConnected) return false;

    final List<String> targets =
        characteristicUuids ??
        (characteristicUuid != null ? <String>[characteristicUuid] : null) ??
        _activeNotifications.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList();

    if (targets.isEmpty) {
      return false;
    }

    try {
      final results = await _bluetoothService.stopDataNotification(
        characteristicUuids: targets,
      );

      bool anyStopped = false;
      for (final MapEntry<String, bool> entry in results.entries) {
        final String normalizedUuid = _normalizeUuid(entry.key);
        if (entry.value) {
          anyStopped = true;
          _activeNotifications.remove(normalizedUuid);
          _latestSensorDataByUuid.remove(normalizedUuid);
          _sensorDataHistoryByUuid.remove(normalizedUuid);
        }
      }

      if (anyStopped) {
        notifyListeners();
      }
      return anyStopped;
    } catch (e) {
      _state = _state.copyWith(errorMessage: '停止数据通知失败: $e');
      notifyListeners();
      return false;
    }
  }

  /// 断开连接
  Future<void> disconnect() async {
    if (!_state.isConnected && !_state.isConnecting) return;

    try {
      await _bluetoothService.disconnect();

      _state = _state.copyWith(
        connectionState: BluetoothConnectionState.disconnected,
        clearConnectedDevice: true,
        clearError: true,
      );
      _clearNotificationState();
      notifyListeners();
    } catch (e) {
      _setError('断开连接失败: $e');
    }
  }

  /// 发送数据到设备
  Future<void> sendData(String data, {String? characteristicUuid}) async {
    if (!_state.isConnected) {
      _setError('设备未连接');
      return;
    }

    try {
      await _bluetoothService.sendData(
        data,
        characteristicUuid: characteristicUuid,
      );
    } catch (e) {
      _setError('发送数据失败: $e');
    }
  }

  /// 添加发现的设备
  void _handleCharacteristicData(CharacteristicDataEvent event) {
    final String normalizedUuid = _normalizeUuid(event.characteristicUuid);

    _activeNotifications[normalizedUuid] = true;
    _latestSensorDataByUuid[normalizedUuid] = event.data;

    final List<SensorData> history = _sensorDataHistoryByUuid.putIfAbsent(
      normalizedUuid,
      () => <SensorData>[],
    );
    history.add(event.data);
    if (history.length > _historyLimit) {
      history.removeAt(0);
    }

    notifyListeners();
  }

  void _clearNotificationState() {
    _activeNotifications.clear();
    _latestSensorDataByUuid.clear();
    _sensorDataHistoryByUuid.clear();
  }

  void clearSensorHistory({List<String>? characteristicUuids}) {
    final List<String> targets = (characteristicUuids ??
            _sensorDataHistoryByUuid.keys.toList())
        .map(_normalizeUuid)
        .toList();

    bool changed = false;
    for (final String uuid in targets) {
      if (_sensorDataHistoryByUuid.containsKey(uuid)) {
        _sensorDataHistoryByUuid[uuid]?.clear();
        changed = true;
      }
      if (_latestSensorDataByUuid.containsKey(uuid)) {
        _latestSensorDataByUuid.remove(uuid);
        changed = true;
      }
    }

    if (changed) {
      notifyListeners();
    }
  }

  String _normalizeUuid(String uuid) => uuid.trim().toLowerCase();

  /// 添加发现的设备
  void _addDiscoveredDevice(DeviceInfo device) {
    final devices = List<DeviceInfo>.from(_state.discoveredDevices);

    // 检查是否已存在
    final existingIndex = devices.indexWhere(
      (d) => d.address == device.address,
    );
    if (existingIndex != -1) {
      devices[existingIndex] = device; // 更新设备信息
    } else {
      devices.add(device); // 添加新设备
    }

    _bluetoothService.sortDiscoveredDevices(devices);

    _state = _state.copyWith(discoveredDevices: devices);
    notifyListeners();
  }

  /// 更新连接状态
  void _updateConnectionState(BluetoothConnectionState connectionState) {
    _state = _state.copyWith(connectionState: connectionState);

    // 如果连接断开，清除连接的设备和RSSI
    if (connectionState == BluetoothConnectionState.disconnected) {
      _state = _state.copyWith(clearConnectedDevice: true, clearRssi: true);
      _clearNotificationState();
    }

    notifyListeners();
  }

  /// 更新RSSI值
  void _updateRssi(int rssi) {
    _state = _state.copyWith(currentRssi: rssi);
    notifyListeners();
  }

  /// 设置错误信息
  void _setError(String message) {
    _state = _state.copyWith(errorMessage: message);
    notifyListeners();
  }

  /// 清除错误信息
  void clearError() {
    _state = _state.copyWith(clearError: true);
    notifyListeners();
  }

  @override
  void dispose() {
    _deviceDiscoverySubscription?.cancel();
    _connectionStateSubscription?.cancel();
    _rssiSubscription?.cancel();
    _characteristicDataSubscription?.cancel();
    _bluetoothService.dispose();
    super.dispose();
  }
}
