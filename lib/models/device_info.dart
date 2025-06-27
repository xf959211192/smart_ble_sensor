/// 设备信息模型
class DeviceInfo {
  final String name;
  final String address;
  final int? rssi; // 信号强度
  final bool isConnected;
  final DateTime? lastConnected;

  DeviceInfo({
    required this.name,
    required this.address,
    this.rssi,
    this.isConnected = false,
    this.lastConnected,
  });

  /// 复制并更新设备信息
  DeviceInfo copyWith({
    String? name,
    String? address,
    int? rssi,
    bool? isConnected,
    DateTime? lastConnected,
  }) {
    return DeviceInfo(
      name: name ?? this.name,
      address: address ?? this.address,
      rssi: rssi ?? this.rssi,
      isConnected: isConnected ?? this.isConnected,
      lastConnected: lastConnected ?? this.lastConnected,
    );
  }

  /// 获取信号强度描述
  String get signalStrengthDescription {
    if (rssi == null) return '未知';

    if (rssi! >= -50) return '优秀';
    if (rssi! >= -60) return '良好';
    if (rssi! >= -70) return '一般';
    return '较弱';
  }

  /// 获取连接状态描述
  String get connectionStatusDescription {
    return isConnected ? '已连接' : '未连接';
  }

  @override
  String toString() {
    return 'DeviceInfo(name: $name, address: $address, connected: $isConnected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceInfo && other.address == address;
  }

  @override
  int get hashCode => address.hashCode;
}
