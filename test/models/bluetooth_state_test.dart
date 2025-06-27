import 'package:flutter_test/flutter_test.dart';
import 'package:smartblesensor/models/models.dart';

void main() {
  group('BluetoothState', () {
    test('should create default state correctly', () {
      final state = BluetoothState();

      expect(state.connectionState, BluetoothConnectionState.disconnected);
      expect(state.scanState, BluetoothScanState.idle);
      expect(state.connectedDevice, isNull);
      expect(state.discoveredDevices, isEmpty);
      expect(state.errorMessage, isNull);
      expect(state.isBluetoothEnabled, false);
    });

    test('should provide correct connection state descriptions', () {
      expect(
        BluetoothState(
          connectionState: BluetoothConnectionState.disconnected,
        ).connectionStateDescription,
        '未连接',
      );
      expect(
        BluetoothState(
          connectionState: BluetoothConnectionState.connecting,
        ).connectionStateDescription,
        '连接中...',
      );
      expect(
        BluetoothState(
          connectionState: BluetoothConnectionState.connected,
        ).connectionStateDescription,
        '已连接',
      );
      expect(
        BluetoothState(
          connectionState: BluetoothConnectionState.disconnecting,
        ).connectionStateDescription,
        '断开连接中...',
      );
      expect(
        BluetoothState(
          connectionState: BluetoothConnectionState.error,
        ).connectionStateDescription,
        '连接错误',
      );
    });

    test('should provide correct scan state descriptions', () {
      expect(
        BluetoothState(scanState: BluetoothScanState.idle).scanStateDescription,
        '空闲',
      );
      expect(
        BluetoothState(
          scanState: BluetoothScanState.scanning,
        ).scanStateDescription,
        '扫描中...',
      );
      expect(
        BluetoothState(
          scanState: BluetoothScanState.stopped,
        ).scanStateDescription,
        '已停止',
      );
      expect(
        BluetoothState(
          scanState: BluetoothScanState.error,
        ).scanStateDescription,
        '扫描错误',
      );
    });

    test('should provide correct status flags', () {
      final connectingState = BluetoothState(
        connectionState: BluetoothConnectionState.connecting,
      );
      final connectedState = BluetoothState(
        connectionState: BluetoothConnectionState.connected,
      );
      final scanningState = BluetoothState(
        scanState: BluetoothScanState.scanning,
      );
      final errorState = BluetoothState(errorMessage: 'Test error');

      expect(connectingState.isConnecting, true);
      expect(connectedState.isConnected, true);
      expect(scanningState.isScanning, true);
      expect(errorState.hasError, true);

      expect(connectedState.isConnecting, false);
      expect(connectingState.isConnected, false);
      expect(connectingState.isScanning, false);
      expect(connectingState.hasError, false);
    });

    test('should copy with updated values', () {
      final device = DeviceInfo(name: 'Test', address: 'addr');
      final devices = [device];

      final original = BluetoothState();
      final updated = original.copyWith(
        connectionState: BluetoothConnectionState.connected,
        connectedDevice: device,
        discoveredDevices: devices,
        isBluetoothEnabled: true,
      );

      expect(updated.connectionState, BluetoothConnectionState.connected);
      expect(updated.connectedDevice, device);
      expect(updated.discoveredDevices, devices);
      expect(updated.isBluetoothEnabled, true);
    });

    test('should clear connected device when specified', () {
      final device = DeviceInfo(name: 'Test', address: 'addr');
      final state = BluetoothState(connectedDevice: device);

      final updated = state.copyWith(clearConnectedDevice: true);

      expect(updated.connectedDevice, isNull);
    });

    test('should clear error when specified', () {
      final state = BluetoothState(errorMessage: 'Test error');

      final updated = state.copyWith(clearError: true);

      expect(updated.errorMessage, isNull);
    });

    test('should create string representation correctly', () {
      final state = BluetoothState(
        connectionState: BluetoothConnectionState.connected,
        scanState: BluetoothScanState.idle,
        discoveredDevices: [
          DeviceInfo(name: 'Device1', address: 'addr1'),
          DeviceInfo(name: 'Device2', address: 'addr2'),
        ],
      );

      expect(
        state.toString(),
        'BluetoothState(connection: 已连接, scan: 空闲, devices: 2)',
      );
    });
  });
}
