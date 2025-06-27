import 'package:flutter_test/flutter_test.dart';
import 'package:smartblesensor/models/models.dart';

void main() {
  group('DeviceInfo', () {
    test('should create device info correctly', () {
      final device = DeviceInfo(
        name: 'ESP32-S3',
        address: '00:11:22:33:44:55',
        rssi: -45,
        isConnected: true,
      );

      expect(device.name, 'ESP32-S3');
      expect(device.address, '00:11:22:33:44:55');
      expect(device.rssi, -45);
      expect(device.isConnected, true);
    });

    test('should provide correct signal strength descriptions', () {
      expect(
        DeviceInfo(
          name: 'Test',
          address: 'addr',
          rssi: -40,
        ).signalStrengthDescription,
        '优秀',
      );
      expect(
        DeviceInfo(
          name: 'Test',
          address: 'addr',
          rssi: -55,
        ).signalStrengthDescription,
        '良好',
      );
      expect(
        DeviceInfo(
          name: 'Test',
          address: 'addr',
          rssi: -65,
        ).signalStrengthDescription,
        '一般',
      );
      expect(
        DeviceInfo(
          name: 'Test',
          address: 'addr',
          rssi: -80,
        ).signalStrengthDescription,
        '较弱',
      );
      expect(
        DeviceInfo(name: 'Test', address: 'addr').signalStrengthDescription,
        '未知',
      );
    });

    test('should provide correct connection status descriptions', () {
      expect(
        DeviceInfo(
          name: 'Test',
          address: 'addr',
          isConnected: true,
        ).connectionStatusDescription,
        '已连接',
      );
      expect(
        DeviceInfo(
          name: 'Test',
          address: 'addr',
          isConnected: false,
        ).connectionStatusDescription,
        '未连接',
      );
    });

    test('should copy with updated values', () {
      final original = DeviceInfo(
        name: 'ESP32-S3',
        address: '00:11:22:33:44:55',
        isConnected: false,
      );

      final updated = original.copyWith(isConnected: true);

      expect(updated.name, 'ESP32-S3');
      expect(updated.address, '00:11:22:33:44:55');
      expect(updated.isConnected, true);
    });

    test('should be equal when addresses are the same', () {
      final device1 = DeviceInfo(name: 'Device1', address: 'addr1');
      final device2 = DeviceInfo(name: 'Device2', address: 'addr1');
      final device3 = DeviceInfo(name: 'Device1', address: 'addr2');

      expect(device1, equals(device2));
      expect(device1, isNot(equals(device3)));
    });

    test('should have same hashCode when addresses are the same', () {
      final device1 = DeviceInfo(name: 'Device1', address: 'addr1');
      final device2 = DeviceInfo(name: 'Device2', address: 'addr1');

      expect(device1.hashCode, equals(device2.hashCode));
    });
  });
}
