import 'package:flutter_test/flutter_test.dart';
import 'package:smartblesensor/models/models.dart';

void main() {
  group('SensorData', () {
    test('should create sensor data correctly', () {
      final data = SensorData(value: 25.5);

      expect(data.value, 25.5);
      expect(data.formattedValue, '25.50');
    });

    test('should create sensor data with factory method', () {
      final data = SensorData.create(120.3);

      expect(data.value, 120.3);
      expect(data.formattedValue, '120.30');
    });

    test('should parse data from raw string', () {
      final data = SensorData.fromRawData('25.5');

      expect(data.value, 25.5);
    });

    test('should parse negative values', () {
      final data = SensorData.fromRawData('-10.2');

      expect(data.value, -10.2);
    });

    test('should throw FormatException for invalid format', () {
      expect(() => SensorData.fromRawData('invalid'), throwsFormatException);
      expect(() => SensorData.fromRawData(''), throwsFormatException);
      expect(() => SensorData.fromRawData('abc'), throwsFormatException);
    });

    test('should format timestamp correctly', () {
      final now = DateTime(2023, 12, 25, 14, 30, 45);
      final data = SensorData(value: 25.5, timestamp: now);

      expect(data.formattedTimestamp, '14:30:45');
    });

    test('should create from binary data', () {
      // 模拟4字节float数据 (25.5)
      final bytes = [0x00, 0x00, 0xCC, 0x41]; // 25.5 in little-endian float
      final data = SensorData.fromBinary(bytes);

      expect(data.value, closeTo(25.5, 0.1));
    });
  });
}
