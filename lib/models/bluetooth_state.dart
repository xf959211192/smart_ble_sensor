import 'device_info.dart';

/// 蓝牙连接状态枚举
enum BluetoothConnectionState {
  disconnected,
  connecting,
  connected,
  disconnecting,
  error,
}

/// 蓝牙扫描状态枚举
enum BluetoothScanState { idle, scanning, stopped, error }

/// 蓝牙状态模型
class BluetoothState {
  final BluetoothConnectionState connectionState;
  final BluetoothScanState scanState;
  final DeviceInfo? connectedDevice;
  final List<DeviceInfo> discoveredDevices;
  final String? errorMessage;
  final bool isBluetoothEnabled;
  final int? currentRssi;

  BluetoothState({
    this.connectionState = BluetoothConnectionState.disconnected,
    this.scanState = BluetoothScanState.idle,
    this.connectedDevice,
    this.discoveredDevices = const [],
    this.errorMessage,
    this.isBluetoothEnabled = false,
    this.currentRssi,
  });

  /// 复制并更新蓝牙状态
  BluetoothState copyWith({
    BluetoothConnectionState? connectionState,
    BluetoothScanState? scanState,
    DeviceInfo? connectedDevice,
    List<DeviceInfo>? discoveredDevices,
    String? errorMessage,
    bool? isBluetoothEnabled,
    int? currentRssi,
    bool clearError = false,
    bool clearConnectedDevice = false,
    bool clearRssi = false,
  }) {
    return BluetoothState(
      connectionState: connectionState ?? this.connectionState,
      scanState: scanState ?? this.scanState,
      connectedDevice: clearConnectedDevice
          ? null
          : (connectedDevice ?? this.connectedDevice),
      discoveredDevices: discoveredDevices ?? this.discoveredDevices,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isBluetoothEnabled: isBluetoothEnabled ?? this.isBluetoothEnabled,
      currentRssi: clearRssi ? null : (currentRssi ?? this.currentRssi),
    );
  }

  /// 获取连接状态描述
  String get connectionStateDescription {
    switch (connectionState) {
      case BluetoothConnectionState.disconnected:
        return '未连接';
      case BluetoothConnectionState.connecting:
        return '连接中...';
      case BluetoothConnectionState.connected:
        return '已连接';
      case BluetoothConnectionState.disconnecting:
        return '断开连接中...';
      case BluetoothConnectionState.error:
        return '连接错误';
    }
  }

  /// 获取扫描状态描述
  String get scanStateDescription {
    switch (scanState) {
      case BluetoothScanState.idle:
        return '空闲';
      case BluetoothScanState.scanning:
        return '扫描中...';
      case BluetoothScanState.stopped:
        return '已停止';
      case BluetoothScanState.error:
        return '扫描错误';
    }
  }

  /// 是否正在连接
  bool get isConnecting =>
      connectionState == BluetoothConnectionState.connecting;

  /// 是否已连接
  bool get isConnected => connectionState == BluetoothConnectionState.connected;

  /// 是否正在扫描
  bool get isScanning => scanState == BluetoothScanState.scanning;

  /// 是否有错误
  bool get hasError => errorMessage != null;

  @override
  String toString() {
    return 'BluetoothState(connection: $connectionStateDescription, scan: $scanStateDescription, devices: ${discoveredDevices.length})';
  }
}
