/// UUID配置数据模型
class UuidConfig {
  final String id;
  final String name;
  final String serviceUuid;
  final String characteristicUuid;
  final String? description;
  final DateTime createdAt;
  final DateTime? lastUsed;

  UuidConfig({
    required this.id,
    required this.name,
    required this.serviceUuid,
    required this.characteristicUuid,
    this.description,
    required this.createdAt,
    this.lastUsed,
  });

  /// 从JSON创建UUID配置
  factory UuidConfig.fromJson(Map<String, dynamic> json) {
    return UuidConfig(
      id: json['id'],
      name: json['name'],
      serviceUuid: json['serviceUuid'],
      characteristicUuid: json['characteristicUuid'],
      description: json['description'],
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
  }) {
    return UuidConfig(
      id: id,
      name: name ?? this.name,
      serviceUuid: serviceUuid ?? this.serviceUuid,
      characteristicUuid: characteristicUuid ?? this.characteristicUuid,
      description: description ?? this.description,
      createdAt: createdAt,
      lastUsed: lastUsed,
    );
  }

  @override
  String toString() {
    return 'UuidConfig(name: $name, service: $serviceUuid, characteristic: $characteristicUuid)';
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
