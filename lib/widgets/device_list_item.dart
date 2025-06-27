import 'package:flutter/material.dart';
import '../models/models.dart';

/// 设备列表项组件
class DeviceListItem extends StatelessWidget {
  final DeviceInfo device;
  final VoidCallback? onTap;
  final bool showConnectionStatus;

  const DeviceListItem({
    super.key,
    required this.device,
    this.onTap,
    this.showConnectionStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _buildDeviceIcon(),
        title: Text(
          device.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(device.address),
            const SizedBox(height: 4),
            _buildDeviceInfo(),
          ],
        ),
        trailing: showConnectionStatus ? _buildConnectionStatus() : null,
        onTap: onTap,
        isThreeLine: true,
      ),
    );
  }

  /// 构建设备图标
  Widget _buildDeviceIcon() {
    IconData iconData;
    Color iconColor;

    if (device.isConnected) {
      iconData = Icons.bluetooth_connected;
      iconColor = Colors.green;
    } else {
      iconData = Icons.bluetooth;
      iconColor = Colors.blue;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withValues(alpha: 0.1),
      child: Icon(iconData, color: iconColor),
    );
  }

  /// 构建设备信息
  Widget _buildDeviceInfo() {
    List<Widget> infoWidgets = [];

    // 信号强度
    if (device.rssi != null) {
      infoWidgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.signal_cellular_alt,
              size: 16,
              color: _getSignalColor(device.rssi!),
            ),
            const SizedBox(width: 4),
            Text(
              '${device.rssi} dBm (${device.signalStrengthDescription})',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }

    // 最后连接时间
    if (device.lastConnected != null) {
      infoWidgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '最后连接: ${_formatDateTime(device.lastConnected!)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }

    if (infoWidgets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(spacing: 8, runSpacing: 4, children: infoWidgets);
  }

  /// 构建连接状态
  Widget _buildConnectionStatus() {
    if (device.isConnected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '已连接',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return const Icon(Icons.chevron_right, color: Colors.grey);
    }
  }

  /// 获取信号强度颜色
  Color _getSignalColor(int rssi) {
    if (rssi >= -50) return Colors.green;
    if (rssi >= -60) return Colors.orange;
    if (rssi >= -70) return Colors.red;
    return Colors.grey;
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}
