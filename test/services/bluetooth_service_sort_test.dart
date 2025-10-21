import 'package:flutter_test/flutter_test.dart';

import 'package:smartblesensor/models/models.dart';
import 'package:smartblesensor/services/bluetooth_service.dart';

void main() {
  group('BluetoothService device sorting', () {
    final BluetoothService service = BluetoothService();

    test('devices with names appear before unnamed ones', () {
      final List<DeviceInfo> devices = <DeviceInfo>[
        DeviceInfo(name: 'Unknown Device', address: '02', rssi: -40),
        DeviceInfo(name: 'Sensor B', address: '03', rssi: -80),
        DeviceInfo(name: 'Sensor A', address: '01', rssi: -60),
      ];

      service.sortDiscoveredDevices(devices);

      expect(devices.first.name, 'Sensor A');
      expect(devices[1].name, 'Sensor B');
      expect(devices.last.name, 'Unknown Device');
    });

    test('stronger signal stays higher within same name bucket', () {
      final List<DeviceInfo> devices = <DeviceInfo>[
        DeviceInfo(name: 'Sensor X', address: '01', rssi: -90),
        DeviceInfo(name: 'Sensor X', address: '02', rssi: -30),
        DeviceInfo(name: 'Sensor X', address: '03', rssi: -60),
      ];

      service.sortDiscoveredDevices(devices);

      expect(devices.map((d) => d.address).toList(), <String>['02', '03', '01']);
    });
  });
}
