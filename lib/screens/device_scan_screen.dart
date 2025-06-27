import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../widgets/device_list_item.dart';

/// 设备扫描屏幕
class DeviceScanScreen extends StatefulWidget {
  const DeviceScanScreen({super.key});

  @override
  State<DeviceScanScreen> createState() => _DeviceScanScreenState();
}

class _DeviceScanScreenState extends State<DeviceScanScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermissionsAndBluetooth();
  }

  /// 检查权限和蓝牙状态
  Future<void> _checkPermissionsAndBluetooth() async {
    final bluetoothProvider = context.read<BluetoothProvider>();

    // 检查权限
    final hasPermissions = await bluetoothProvider.checkPermissions();
    if (!hasPermissions) {
      _showPermissionDialog();
      return;
    }

    // 检查蓝牙是否启用
    if (!bluetoothProvider.isBluetoothEnabled) {
      _showBluetoothDialog();
    }
  }

  /// 显示权限对话框
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('需要 BLE 权限'),
        content: const Text('应用需要蓝牙低功耗 (BLE 5.0) 和位置权限才能扫描智能传感器设备。请在设置中授予权限。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示蓝牙对话框
  void _showBluetoothDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('BLE 5.0 未启用'),
        content: const Text('请启用蓝牙低功耗 (BLE 5.0) 以扫描智能传感器设备。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<BluetoothProvider>().enableBluetooth();
            },
            child: const Text('启用'),
          ),
        ],
      ),
    );
  }

  /// 开始扫描
  void _startScan() {
    context.read<BluetoothProvider>().startScan();
  }

  /// 停止扫描
  void _stopScan() {
    context.read<BluetoothProvider>().stopScan();
  }

  /// 连接设备
  void _connectToDevice(DeviceInfo device) async {
    if (!mounted) return;

    final bluetoothProvider = context.read<BluetoothProvider>();

    // 显示连接中的提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text('正在连接 ${device.name}...'),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );

    // 建立BLE连接
    await bluetoothProvider.connectToDevice(device);

    if (!mounted) return;

    // 检查连接状态并显示相应反馈
    if (bluetoothProvider.state.isConnected) {
      // 连接成功
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('已连接到 ${device.name}'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // 延迟一下让用户看到成功提示，然后返回主页面
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.of(context).pop(); // 返回主页面
      }
    } else {
      // 连接失败
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Text('连接 ${device.name} 失败'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE 5.0 设备扫描'),
        actions: [
          Consumer<BluetoothProvider>(
            builder: (context, bluetoothProvider, child) {
              if (bluetoothProvider.isScanning) {
                return IconButton(
                  onPressed: _stopScan,
                  icon: const Icon(Icons.stop),
                  tooltip: '停止扫描',
                );
              } else {
                return IconButton(
                  onPressed: bluetoothProvider.isBluetoothEnabled
                      ? _startScan
                      : null,
                  icon: const Icon(Icons.search),
                  tooltip: '开始扫描',
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<BluetoothProvider>(
        builder: (context, bluetoothProvider, child) {
          // 显示错误信息
          if (bluetoothProvider.errorMessage != null) {
            return _buildErrorView(bluetoothProvider.errorMessage!);
          }

          // 蓝牙未启用
          if (!bluetoothProvider.isBluetoothEnabled) {
            return _buildBluetoothDisabledView();
          }

          // 扫描状态
          if (bluetoothProvider.isScanning) {
            return _buildScanningView(bluetoothProvider.discoveredDevices);
          }

          // 设备列表
          return _buildDeviceList(bluetoothProvider.discoveredDevices);
        },
      ),
      floatingActionButton: Consumer<BluetoothProvider>(
        builder: (context, bluetoothProvider, child) {
          if (!bluetoothProvider.isBluetoothEnabled) {
            return FloatingActionButton(
              onPressed: () => bluetoothProvider.enableBluetooth(),
              tooltip: '启用蓝牙',
              child: const Icon(Icons.bluetooth_disabled),
            );
          }

          if (bluetoothProvider.isScanning) {
            return FloatingActionButton(
              onPressed: _stopScan,
              backgroundColor: Colors.red,
              tooltip: '停止扫描',
              child: const Icon(Icons.stop),
            );
          }

          return FloatingActionButton(
            onPressed: _startScan,
            tooltip: '开始扫描',
            child: const Icon(Icons.search),
          );
        },
      ),
    );
  }

  /// 构建错误视图
  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('错误', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<BluetoothProvider>().clearError(),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 构建蓝牙未启用视图
  Widget _buildBluetoothDisabledView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bluetooth_disabled, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('BLE 5.0 未启用', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('请启用蓝牙低功耗以扫描智能传感器'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                context.read<BluetoothProvider>().enableBluetooth(),
            child: const Text('启用 BLE 5.0'),
          ),
        ],
      ),
    );
  }

  /// 构建扫描中视图
  Widget _buildScanningView(List<DeviceInfo> devices) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text('正在扫描设备...', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        Expanded(child: _buildDeviceList(devices)),
      ],
    );
  }

  /// 构建设备列表
  Widget _buildDeviceList(List<DeviceInfo> devices) {
    if (devices.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.devices, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('未发现设备'),
            SizedBox(height: 8),
            Text('点击扫描按钮开始搜索设备'),
          ],
        ),
      );
    }

    // 按信号强度排序（RSSI值越大信号越强）
    final sortedDevices = List<DeviceInfo>.from(devices);
    sortedDevices.sort((a, b) {
      // RSSI为null的设备排在最后
      if (a.rssi == null && b.rssi == null) return 0;
      if (a.rssi == null) return 1;
      if (b.rssi == null) return -1;
      // RSSI值越大（越接近0）信号越强，排在前面
      return b.rssi!.compareTo(a.rssi!);
    });

    return ListView.builder(
      itemCount: sortedDevices.length,
      itemBuilder: (context, index) {
        final device = sortedDevices[index];
        return DeviceListItem(
          device: device,
          onTap: () => _connectToDevice(device),
        );
      },
    );
  }
}
