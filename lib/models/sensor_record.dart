import 'dart:collection';

/// Represents a snapshot of sensor readings captured at the same timestamp.
///
/// Each record stores one or more BLE characteristic readings keyed by their
/// canonical UUID (lowercase, trimmed). This enables multi-channel recordings
/// where multiple characteristics are sampled simultaneously.
class SensorRecord {
  SensorRecord({
    required DateTime timestamp,
    required Map<String, double> valuesByUuid,
  })  : timestamp = timestamp.toUtc(),
        _valuesByUuid = Map.unmodifiable(
          _normalizeValuesMap(valuesByUuid),
        );

  /// Creates a record for a single UUID/value pair.
  factory SensorRecord.single({
    required String uuid,
    required double value,
    DateTime? timestamp,
  }) {
    return SensorRecord(
      timestamp: timestamp ?? DateTime.now().toUtc(),
      valuesByUuid: {uuid: value},
    );
  }

  factory SensorRecord.fromJson(Map<String, dynamic> json) {
    final rawTimestamp = json['timestamp'];
    final rawValues = json['values'] as Map<String, dynamic>? ?? {};

    return SensorRecord(
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        rawTimestamp as int,
        isUtc: true,
      ),
      valuesByUuid: _normalizeValuesMap(rawValues),
    );
  }

  final DateTime timestamp;
  final Map<String, double> _valuesByUuid;

  /// Returns the recorded values keyed by normalized UUID.
  Map<String, double> get valuesByUuid =>
      UnmodifiableMapView<String, double>(_valuesByUuid);

  /// Returns the value for the provided UUID (case-insensitive).
  double? valueForUuid(String uuid) => _valuesByUuid[_normalizeUuid(uuid)];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'timestamp': timestamp.millisecondsSinceEpoch,
      'values': _valuesByUuid,
    };
  }

  SensorRecord copyWith({
    DateTime? timestamp,
    Map<String, double>? valuesByUuid,
  }) {
    return SensorRecord(
      timestamp: (timestamp ?? this.timestamp).toUtc(),
      valuesByUuid: valuesByUuid ?? _valuesByUuid,
    );
  }

  static Map<String, double> _normalizeValuesMap(
    Map<String, dynamic> rawValues,
  ) {
    final Map<String, double> normalized = {};
    rawValues.forEach((key, value) {
      final normalizedKey = _normalizeUuid(key);
      if (normalizedKey.isEmpty) return;

      final double parsedValue;
      if (value is num) {
        parsedValue = value.toDouble();
      } else if (value is String) {
        final trimmed = value.trim();
        if (trimmed.isEmpty) return;
        parsedValue = double.tryParse(trimmed) ?? double.nan;
      } else {
        return;
      }

      if (parsedValue.isNaN) return;
      normalized[normalizedKey] = parsedValue;
    });
    return normalized;
  }

  static String _normalizeUuid(String uuid) => uuid.trim().toLowerCase();
}
