/// UUID配置数据模型
class UuidConfig {
  final String id;
  final String name;
  final String serviceUuid;
  final String characteristicUuid;
  final String? description;

  /// 数据单位，例如 ℃、%RH
  final String? unit;
  final DateTime createdAt;
  final DateTime? lastUsed;

  UuidConfig({
    required this.id,
    required this.name,
    required this.serviceUuid,
    required this.characteristicUuid,
    this.description,
    this.unit,
    required this.createdAt,
    this.lastUsed,
  });

  /// 从JSON创建UUID配置
  factory UuidConfig.fromJson(Map<String, dynamic> json) {
    String? normalizedUnit;
    final dynamic rawUnit = json['unit'];
    if (rawUnit is String) {
      final String trimmed = rawUnit.trim();
      if (trimmed.isNotEmpty) {
        normalizedUnit = trimmed;
      }
    }
    return UuidConfig(
      id: json['id'],
      name: json['name'],
      serviceUuid: json['serviceUuid'],
      characteristicUuid: json['characteristicUuid'],
      description: json['description'],
      unit: normalizedUnit,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      lastUsed: json['lastUsed'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastUsed'])
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serviceUuid': serviceUuid,
      'characteristicUuid': characteristicUuid,
      'description': description,
      'unit': unit,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastUsed': lastUsed?.millisecondsSinceEpoch,
    };
  }

  /// 创建副本并更新最后使用时间
  UuidConfig copyWithLastUsed(DateTime lastUsed) {
    return UuidConfig(
      id: id,
      name: name,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      description: description,
      unit: unit,
      createdAt: createdAt,
      lastUsed: lastUsed,
    );
  }

  /// 创建副本并更新字段
  UuidConfig copyWith({
    String? name,
    String? serviceUuid,
    String? characteristicUuid,
    String? description,
    String? unit,
    bool clearDescription = false,
    bool clearUnit = false,
  }) {
    return UuidConfig(
      id: id,
      name: name ?? this.name,
      serviceUuid: serviceUuid ?? this.serviceUuid,
      characteristicUuid: characteristicUuid ?? this.characteristicUuid,
      description: clearDescription ? null : (description ?? this.description),
      unit: clearUnit ? null : (unit ?? this.unit),
      createdAt: createdAt,
      lastUsed: lastUsed,
    );
  }

  @override
  String toString() {
    final String unitInfo = unit == null ? '' : ', unit: $unit';
    return 'UuidConfig(name: $name, service: $serviceUuid, characteristic: $characteristicUuid$unitInfo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UuidConfig &&
        other.id == id &&
        other.serviceUuid == serviceUuid &&
        other.characteristicUuid == characteristicUuid;
  }

  @override
  int get hashCode {
    return id.hashCode ^ serviceUuid.hashCode ^ characteristicUuid.hashCode;
  }
}
