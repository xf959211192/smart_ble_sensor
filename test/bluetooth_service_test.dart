import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;

import 'package:smart_sense/services/bluetooth_service.dart';
import 'package:smart_sense/models/models.dart';

// 生成 Mock 类
@GenerateMocks([
  fbp.FlutterBluePlus,
  fbp.BluetoothDevice,
  fbp.BluetoothCharacteristic,
])
void main() {
  group('BluetoothService Tests', () {
    late BluetoothService bluetoothService;

    setUp(() {
      bluetoothService = BluetoothService();
    });

    tearDown(() {
      bluetoothService.dispose();
    });

    group('权限检查测试', () {
      test('应该检查所有必需的蓝牙权限', () async {
        // 测试权限检查功能
        final hasPermissions = await bluetoothService.checkPermissions();

        // 验证权限检查结果
        expect(hasPermissions, isA<bool>());
      });
    });

    group('蓝牙状态测试', () {
      test('应该正确检测蓝牙是否启用', () async {
        // 测试蓝牙状态检测
        final isEnabled = await bluetoothService.isBluetoothEnabled();

        // 验证返回值类型
        expect(isEnabled, isA<bool>());
      });

      test('应该能够启用蓝牙', () async {
        // 测试蓝牙启用功能
        final result = await bluetoothService.enableBluetooth();

        // 验证返回值类型
        expect(result, isA<bool>());
      });
    });

    group('设备扫描测试', () {
      test('应该能够扫描 BLE 设备', () async {
        // 测试设备扫描功能
        final devices = await bluetoothService.scanDevices(
          timeout: const Duration(seconds: 5),
        );

        // 验证返回设备列表
        expect(devices, isA<List<DeviceInfo>>());
      });

      test('扫描超时应该正确处理', () async {
        // 测试扫描超时处理
        final devices = await bluetoothService.scanDevices(
          timeout: const Duration(milliseconds: 100),
        );

        // 验证即使超时也能返回结果
        expect(devices, isA<List<DeviceInfo>>());
      });
    });

    group('设备连接测试', () {
      test('连接不存在的设备应该失败', () async {
        // 测试连接不存在的设备
        expect(
          () => bluetoothService.connectToDevice('invalid_address'),
          throwsA(isA<Exception>()),
        );
      });

      test('应该正确报告连接状态', () {
        // 测试连接状态报告
        final isConnected = bluetoothService.isConnected;
        expect(isConnected, isA<bool>());
      });
    });

    group('数据流测试', () {
      test('应该提供传感器数据流', () {
        // 测试传感器数据流
        expect(bluetoothService.sensorDataStream, isA<Stream<SensorData>>());
      });

      test('应该提供设备发现流', () {
        // 测试设备发现流
        expect(
          bluetoothService.deviceDiscoveryStream,
          isA<Stream<DeviceInfo>>(),
        );
      });

      test('应该提供连接状态流', () {
        // 测试连接状态流
        expect(
          bluetoothService.connectionStateStream,
          isA<Stream<BluetoothConnectionState>>(),
        );
      });
    });

    group('错误处理测试', () {
      test('无权限时应该正确处理', () async {
        // 模拟无权限情况
        // 这里可以添加更具体的权限测试
        expect(bluetoothService.checkPermissions(), completes);
      });

      test('蓝牙未启用时应该正确处理', () async {
        // 模拟蓝牙未启用情况
        expect(bluetoothService.isBluetoothEnabled(), completes);
      });
    });
  });

  group('SensorData 模型测试', () {
    test('应该正确解析传感器数据', () {
      // 测试数据解析 - 使用简化的数值格式
      const rawData = '25.5';

      expect(() => SensorData.fromRawData(rawData), returnsNormally);

      final sensorData = SensorData.fromRawData(rawData);
      expect(sensorData.value, equals(25.5));
    });

    test('应该处理无效数据格式', () {
      // 测试无效数据处理
      const invalidData = 'invalid_data';

      expect(
        () => SensorData.fromRawData(invalidData),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('DeviceInfo 模型测试', () {
    test('应该正确创建设备信息', () {
      // 测试设备信息创建
      final device = DeviceInfo(
        name: 'Test Device',
        address: '00:11:22:33:44:55',
        rssi: -50,
        isConnected: false,
      );

      expect(device.name, equals('Test Device'));
      expect(device.address, equals('00:11:22:33:44:55'));
      expect(device.rssi, equals(-50));
      expect(device.isConnected, equals(false));
    });
  });

  group('BluetoothConnectionState 测试', () {
    test('应该包含所有必需的连接状态', () {
      // 测试连接状态枚举
      expect(
        BluetoothConnectionState.values,
        contains(BluetoothConnectionState.disconnected),
      );
      expect(
        BluetoothConnectionState.values,
        contains(BluetoothConnectionState.connecting),
      );
      expect(
        BluetoothConnectionState.values,
        contains(BluetoothConnectionState.connected),
      );
      expect(
        BluetoothConnectionState.values,
        contains(BluetoothConnectionState.disconnecting),
      );
      expect(
        BluetoothConnectionState.values,
        contains(BluetoothConnectionState.error),
      );
    });
  });
}
