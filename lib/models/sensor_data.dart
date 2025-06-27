import 'dart:typed_data';
import 'package:intl/intl.dart';

/// 通用传感器数据模型
class SensorData {
  final double value;
  final DateTime timestamp;

  SensorData({required this.value, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  /// 创建传感器数据
  factory SensorData.create(double value) {
    return SensorData(value: value);
  }

  /// 从原始字符串数据解析 (格式: "25.5")
  factory SensorData.fromRawData(String rawData) {
    if (rawData.isEmpty) {
      throw FormatException('Raw data cannot be empty');
    }

    final double value;
    try {
      value = double.parse(rawData.trim());
    } catch (e) {
      throw FormatException('Invalid value: $rawData');
    }

    return SensorData(value: value);
  }

  /// 从二进制数据创建 (4字节float)
  factory SensorData.fromBinary(List<int> data) {
    if (data.length != 4) {
      throw FormatException(
        'Invalid binary data length: ${data.length}, expected 4 bytes',
      );
    }

    // 将List<int>转换为Uint8List，然后解析为float
    Uint8List bytes = Uint8List.fromList(data);
    ByteData byteData = ByteData.sublistView(bytes);

    // 读取小端序的float值（ESP32默认使用小端序）
    double floatValue = byteData.getFloat32(0, Endian.little);

    return SensorData(value: floatValue);
  }

  /// 获取格式化的时间戳
  String get formattedTimestamp {
    return DateFormat('HH:mm:ss').format(timestamp);
  }

  /// 获取格式化的值 (保留2位小数)
  String get formattedValue {
    return value.toStringAsFixed(2);
  }

  /// 获取指定精度的格式化值
  String getFormattedValue(int decimalPlaces) {
    return value.toStringAsFixed(decimalPlaces);
  }
}
