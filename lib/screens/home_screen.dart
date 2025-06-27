import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../services/uuid_config_service.dart';
import 'device_scan_screen.dart';

/// 主屏幕
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _DeviceManagementTab(),
    const _DataMonitoringTab(),
    const _RecordsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: '设备'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: '监控'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '记录'),
        ],
      ),
    );
  }
}

/// 设备管理标签页
class _DeviceManagementTab extends StatelessWidget {
  const _DeviceManagementTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设备管理'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildConnectedDeviceCard(context),
            const SizedBox(height: 16),
            _buildDeviceInfoCard(),
          ],
        ),
      ),
    );
  }

  /// 构建已连接设备卡片
  Widget _buildConnectedDeviceCard(BuildContext context) {
    return Consumer<BluetoothProvider>(
      builder: (context, bluetoothProvider, child) {
        final isConnected = bluetoothProvider.state.isConnected;
        final connectedDevice = bluetoothProvider.state.connectedDevice;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '已连接设备',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isConnected ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isConnected ? '已连接' : '未连接',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                isConnected ? (connectedDevice?.name ?? '未知设备') : '无连接设备',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isConnected
                      ? () => _disconnect(context)
                      : () => _showDeviceScanDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isConnected ? Colors.red : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(isConnected ? '断开连接' : '连接设备'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建设备信息卡片
  Widget _buildDeviceInfoCard() {
    return Consumer<BluetoothProvider>(
      builder: (context, bluetoothProvider, child) {
        final isConnected = bluetoothProvider.state.isConnected;
        final connectedDevice = bluetoothProvider.state.connectedDevice;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '设备信息',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                '信号强度:',
                isConnected ? '${connectedDevice?.rssi ?? '--'} dBm' : '-- dBm',
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  /// 断开连接
  void _disconnect(BuildContext context) {
    final bluetoothProvider = Provider.of<BluetoothProvider>(
      context,
      listen: false,
    );
    bluetoothProvider.disconnect();
  }

  /// 显示设备扫描对话框
  void _showDeviceScanDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DeviceScanScreen()),
    );
  }
}

/// 数据监控标签页
class _DataMonitoringTab extends StatefulWidget {
  const _DataMonitoringTab();

  @override
  State<_DataMonitoringTab> createState() => _DataMonitoringTabState();
}

class _DataMonitoringTabState extends State<_DataMonitoringTab> {
  UuidConfig? _selectedConfig;
  bool _isDataNotificationActive = false; // 数据通知是否已激活

  // 实时数据存储
  final List<FlSpot> _sensorData = [];
  final int _maxDataPoints = 50; // 最多显示50个数据点
  double _timeIndex = 0;

  // UUID配置服务
  final UuidConfigService _uuidConfigService = UuidConfigService();

  @override
  void initState() {
    super.initState();
    _startListeningToSensorData();
    _loadSelectedConfig();
  }

  /// 加载选中的UUID配置
  Future<void> _loadSelectedConfig() async {
    final config = await _uuidConfigService.getSelectedConfig();
    if (mounted) {
      setState(() {
        _selectedConfig = config;
      });
    }
  }

  @override
  void dispose() {
    final sensorDataProvider = context.read<SensorDataProvider>();
    sensorDataProvider.removeListener(_onSensorDataChanged);
    super.dispose();
  }

  /// 开始监听传感器数据
  void _startListeningToSensorData() {
    final sensorDataProvider = context.read<SensorDataProvider>();
    sensorDataProvider.addListener(_onSensorDataChanged);
  }

  /// 传感器数据变化回调
  void _onSensorDataChanged() {
    final sensorDataProvider = context.read<SensorDataProvider>();
    final latestData = sensorDataProvider.latestData;

    if (latestData != null && mounted) {
      setState(() {
        // 添加新的传感器数据点
        _sensorData.add(FlSpot(_timeIndex, latestData.value));
        _timeIndex++;

        // 保持最大数据点数量
        if (_sensorData.length > _maxDataPoints) {
          _sensorData.removeAt(0);
          // 不需要调整_timeIndex，让它继续递增以保持时间连续性
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('实时监控'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showCharacteristicSelector,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Consumer<BluetoothProvider>(
        builder: (context, bluetoothProvider, child) {
          if (!bluetoothProvider.isConnected) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bluetooth_disabled, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '请先连接蓝牙设备',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildConnectionStatus(bluetoothProvider),
                const SizedBox(height: 16),
                _buildCurrentDataCard(),
                const SizedBox(height: 16),
                Expanded(child: _buildSensorChart()),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 构建连接状态卡片
  Widget _buildConnectionStatus(BluetoothProvider bluetoothProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 设备连接信息
          Row(
            children: [
              Icon(Icons.bluetooth_connected, color: Colors.green, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '已连接: ${bluetoothProvider.connectedDevice?.name ?? '未知设备'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bluetoothProvider.connectedDevice?.address ?? '',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _isDataNotificationActive
                      ? Colors.green
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _isDataNotificationActive ? '监听中' : '未监听',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // UUID配置和控制按钮
          Column(
            children: [
              // 第一行：UUID配置信息
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedConfig != null
                              ? 'UUID配置: ${_selectedConfig!.name}'
                              : 'UUID配置: 未选择',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_selectedConfig != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            _selectedConfig!.description ?? '无描述',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // UUID选择按钮
                  ElevatedButton.icon(
                    onPressed: () => _showCharacteristicSelector(),
                    icon: const Icon(Icons.settings, size: 16),
                    label: const Text('选择UUID'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 第二行：控制按钮
              Row(
                children: [
                  // 开始/停止监听按钮
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isDataNotificationActive
                          ? _stopDataNotification
                          : _startDataNotification,
                      icon: Icon(
                        _isDataNotificationActive
                            ? Icons.stop
                            : Icons.play_arrow,
                        size: 16,
                      ),
                      label: Text(_isDataNotificationActive ? '停止监听' : '开始监听'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isDataNotificationActive
                            ? Colors.red
                            : Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 清空图表按钮
                  ElevatedButton.icon(
                    onPressed: _sensorData.isNotEmpty ? _clearChartData : null,
                    icon: const Icon(Icons.clear_all, size: 16),
                    label: const Text('清空图表'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 显示UUID配置管理器
  void _showCharacteristicSelector() async {
    final configs = await _uuidConfigService.getAllConfigs();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('UUID配置管理'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 保存的配置列表
              if (configs.isNotEmpty) ...[
                const Text(
                  '保存的配置:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...configs.map((config) => _buildConfigTile(config)),
                const Divider(),
              ],

              // 添加新配置按钮
              ListTile(
                title: const Text('添加新配置'),
                subtitle: const Text('创建新的UUID配置'),
                leading: const Icon(Icons.add, color: Colors.green),
                onTap: () {
                  Navigator.pop(context);
                  _showAddConfigDialog();
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 构建配置项瓦片
  Widget _buildConfigTile(UuidConfig config) {
    return ListTile(
      title: Text(config.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (config.description != null)
            Text(
              config.description!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          Text(
            '服务: ${config.serviceUuid}',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          Text(
            '特征值: ${config.characteristicUuid}',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          if (config.lastUsed != null)
            Text(
              '最后使用: ${_formatDateTime(config.lastUsed!)}',
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
        ],
      ),
      leading: Radio<String>(
        value: config.id,
        groupValue: _selectedConfig?.id ?? '',
        onChanged: (value) {
          setState(() {
            _selectedConfig = config;
          });
          _uuidConfigService.setSelectedConfig(config.id);
          Navigator.pop(context);
          _onConfigChanged();
        },
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            _showEditConfigDialog(config);
          } else if (value == 'delete') {
            _showDeleteConfigDialog(config);
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 16),
                SizedBox(width: 8),
                Text('编辑'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 16, color: Colors.red),
                SizedBox(width: 8),
                Text('删除', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 显示添加配置对话框
  void _showAddConfigDialog() {
    _showConfigDialog();
  }

  /// 显示编辑配置对话框
  void _showEditConfigDialog(UuidConfig config) {
    _showConfigDialog(config: config);
  }

  /// 构建当前数据卡片
  Widget _buildCurrentDataCard() {
    return Consumer<SensorDataProvider>(
      builder: (context, sensorDataProvider, child) {
        final latestData = sensorDataProvider.latestData;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.sensors, color: Colors.green, size: 48),
              const SizedBox(height: 12),
              const Text(
                '传感器数据',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                latestData?.formattedValue ?? '--',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                latestData != null
                    ? '更新时间: ${latestData.formattedTimestamp}'
                    : '等待数据...',
                style: const TextStyle(fontSize: 12, color: Colors.black38),
              ),
              const SizedBox(height: 8),
              // RSSI信号强度显示
              Consumer<BluetoothProvider>(
                builder: (context, bluetoothProvider, child) {
                  final isConnected = bluetoothProvider.isConnected;
                  final currentRssi = bluetoothProvider.state.currentRssi;

                  if (isConnected && currentRssi != null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.signal_cellular_alt,
                          size: 16,
                          color: _getRssiColor(currentRssi),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$currentRssi dBm',
                          style: TextStyle(
                            fontSize: 12,
                            color: _getRssiColor(currentRssi),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getRssiDescription(currentRssi),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getRssiColor(currentRssi),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建传感器数据图表
  Widget _buildSensorChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.blue.shade50.withValues(alpha: 0.3)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            spreadRadius: -2,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border.all(color: Colors.blue.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 8),
              const Text(
                '实时数据图表',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_sensorData.length}个数据点',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.blue.shade800,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        return LineTooltipItem(
                          '数值: ${flSpot.y.toStringAsFixed(2)}\n时间: ${((_timeIndex - flSpot.x).toInt())}s前',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? touchResponse) {
                        // 可以在这里添加触摸回调逻辑
                      },
                  handleBuiltInTouches: true,
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 5,
                  verticalInterval: _sensorData.length > 10 ? 10 : 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.blue.withValues(alpha: 0.1),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.blue.withValues(alpha: 0.1),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: _sensorData.length > 10
                          ? (_sensorData.length / 5).ceilToDouble()
                          : 2,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        // 显示相对时间（秒前）
                        if (_sensorData.isNotEmpty) {
                          final latestX = _sensorData.last.x;
                          final secondsAgo = (latestX - value).toInt();
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              secondsAgo == 0 ? '现在' : '${secondsAgo}s前',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            '${value.toInt()}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 42,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            '${value.toInt()}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                minX: _sensorData.isEmpty
                    ? 0
                    : _sensorData.length < _maxDataPoints
                    ? 0
                    : _sensorData.first.x,
                maxX: _sensorData.isEmpty
                    ? 10
                    : _sensorData.length < _maxDataPoints
                    ? _maxDataPoints.toDouble()
                    : _sensorData.last.x,
                minY: _getMinValue() - 2,
                maxY: _getMaxValue() + 2,
                lineBarsData: [
                  LineChartBarData(
                    spots: _sensorData.isEmpty
                        ? [const FlSpot(0, 0)]
                        : _sensorData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade400,
                        Colors.cyan.shade300,
                        Colors.teal.shade400,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        // 最新数据点高亮显示
                        final isLatest = index == _sensorData.length - 1;
                        return FlDotCirclePainter(
                          radius: isLatest ? 5 : 3,
                          color: isLatest
                              ? Colors.orange
                              : Colors.blue.shade600,
                          strokeWidth: isLatest ? 3 : 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withValues(alpha: 0.3),
                          Colors.cyan.withValues(alpha: 0.1),
                          Colors.teal.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 获取数据的最小值
  double _getMinValue() {
    if (_sensorData.isEmpty) return 0;
    return _sensorData.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
  }

  /// 获取数据的最大值
  double _getMaxValue() {
    if (_sensorData.isEmpty) return 10;
    return _sensorData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
  }

  /// 根据RSSI值获取颜色
  Color _getRssiColor(int rssi) {
    if (rssi >= -50) return Colors.green;
    if (rssi >= -60) return Colors.lightGreen;
    if (rssi >= -70) return Colors.orange;
    return Colors.red;
  }

  /// 根据RSSI值获取描述
  String _getRssiDescription(int rssi) {
    if (rssi >= -50) return '优秀';
    if (rssi >= -60) return '良好';
    if (rssi >= -70) return '一般';
    return '较弱';
  }

  /// 开始数据监听
  void _startDataNotification() async {
    final bluetoothProvider = context.read<BluetoothProvider>();

    if (!bluetoothProvider.state.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先连接设备'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_selectedConfig == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先选择UUID配置'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 使用选中的UUID配置
    bool success = await bluetoothProvider.setupDataNotification(
      serviceUuid: _selectedConfig!.serviceUuid,
      characteristicUuid: _selectedConfig!.characteristicUuid,
    );

    if (mounted) {
      setState(() {
        _isDataNotificationActive = success;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.play_arrow, color: Colors.white),
                SizedBox(width: 12),
                Text('数据监听已启动'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Text('启动监听失败，请检查UUID配置'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// 停止数据监听
  void _stopDataNotification() async {
    final bluetoothProvider = context.read<BluetoothProvider>();

    // 停止数据通知，但保持BLE连接
    final success = await bluetoothProvider.stopDataNotification();

    if (mounted) {
      setState(() {
        _isDataNotificationActive = false;
        // 注意：不清空图表数据，让用户可以查看历史数据
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '已停止数据监听，连接保持' : '停止监听失败'),
          backgroundColor: success ? Colors.orange : Colors.red,
        ),
      );
    }
  }

  /// 清空图表数据
  void _clearChartData() {
    setState(() {
      _sensorData.clear();
      _timeIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('图表数据已清空'), backgroundColor: Colors.blue),
    );
  }

  /// 配置更改后的处理 (不重连，只停止当前监听)
  void _onConfigChanged() {
    if (_isDataNotificationActive) {
      // 如果正在监听，先停止监听
      _stopDataNotification();

      // 提示用户重新开始监听
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('UUID配置已更改，请重新点击"开始监听"'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// 显示配置对话框
  void _showConfigDialog({UuidConfig? config}) {
    final nameController = TextEditingController(text: config?.name ?? '');
    final serviceController = TextEditingController(
      text: config?.serviceUuid ?? '',
    );
    final characteristicController = TextEditingController(
      text: config?.characteristicUuid ?? '',
    );
    final descriptionController = TextEditingController(
      text: config?.description ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(config == null ? '添加UUID配置' : '编辑UUID配置'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '配置名称',
                  hintText: '例如: ESP32温度传感器',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: serviceController,
                decoration: const InputDecoration(
                  labelText: '服务UUID',
                  hintText: '例如: 4fafc201-1fb5-459e-8fcc-c5c9c331914b',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: characteristicController,
                decoration: const InputDecoration(
                  labelText: '特征值UUID',
                  hintText: '例如: beb5483e-36e1-4688-b7f5-ea07361b26a8',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: '备注描述（可选）',
                  hintText: '例如: 用于温度监测的ESP32设备',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => _saveConfig(
              config,
              nameController.text,
              serviceController.text,
              characteristicController.text,
              descriptionController.text,
            ),
            child: Text(config == null ? '添加' : '保存'),
          ),
        ],
      ),
    );
  }

  /// 保存配置
  void _saveConfig(
    UuidConfig? existingConfig,
    String name,
    String serviceUuid,
    String characteristicUuid,
    String description,
  ) {
    if (name.trim().isEmpty ||
        serviceUuid.trim().isEmpty ||
        characteristicUuid.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请填写配置名称、服务UUID和特征值UUID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!UuidConfigService.isValidUuid(serviceUuid.trim()) ||
        !UuidConfigService.isValidUuid(characteristicUuid.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('UUID格式不正确，请检查输入'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newConfig = UuidConfig(
      id: existingConfig?.id ?? UuidConfigService.generateId(),
      name: name.trim(),
      serviceUuid: serviceUuid.trim(),
      characteristicUuid: characteristicUuid.trim(),
      description: description.trim().isEmpty ? null : description.trim(),
      createdAt: existingConfig?.createdAt ?? DateTime.now(),
      lastUsed: existingConfig?.lastUsed,
    );

    _uuidConfigService.saveConfig(newConfig).then((success) {
      if (!mounted) return;

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(existingConfig == null ? '配置已添加' : '配置已更新'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() {}); // 刷新UI
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Text('保存失败，请重试'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }

  /// 显示删除配置对话框
  void _showDeleteConfigDialog(UuidConfig config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除配置"${config.name}"吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // 在async操作之前获取引用
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              _uuidConfigService.deleteConfig(config.id).then((success) {
                if (!mounted) return;

                navigator.pop();
                if (success) {
                  // 如果删除的是当前选中的配置，清除选择
                  if (_selectedConfig?.id == config.id) {
                    setState(() {
                      _selectedConfig = null;
                    });
                    _uuidConfigService.clearSelectedConfig();
                  }
                  if (mounted) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            SizedBox(width: 12),
                            Text('配置已删除'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    setState(() {}); // 刷新UI
                  }
                } else {
                  if (mounted) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error, color: Colors.white),
                            SizedBox(width: 12),
                            Text('删除失败，请重试'),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                }
              });
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// 记录标签页
class _RecordsTab extends StatefulWidget {
  const _RecordsTab();

  @override
  State<_RecordsTab> createState() => _RecordsTabState();
}

class _RecordsTabState extends State<_RecordsTab> {
  final List<SensorRecord> _records = [];
  bool _isRecording = false;
  Timer? _recordingTimer;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('数据记录'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _records.isNotEmpty ? _exportToCSV : null,
            tooltip: '导出CSV',
          ),
          IconButton(
            icon: Icon(_isRecording ? Icons.stop : Icons.play_arrow),
            onPressed: _toggleRecording,
            color: _isRecording ? Colors.red : Colors.green,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRecordingStatus(),
            const SizedBox(height: 16),
            _buildRecordsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearAllRecords,
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete_forever, color: Colors.white),
      ),
    );
  }

  /// 构建记录状态卡片
  Widget _buildRecordingStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '记录状态',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _isRecording ? '记录中' : '已停止',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    '总记录数',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_records.length}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              Column(
                children: [
                  const Text(
                    '记录间隔',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1秒',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建记录列表
  Widget _buildRecordsList() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.2),
                ),
              ),
              child: const Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      '时间戳',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '传感器数值',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _records.isEmpty
                  ? const Center(
                      child: Text(
                        '暂无记录数据\n点击右上角播放按钮开始记录',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _records.length,
                      itemBuilder: (context, index) {
                        final record =
                            _records[_records.length - 1 - index]; // 倒序显示
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withValues(alpha: 0.1),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _formatTimestamp(record.timestamp),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  record.value.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 切换记录状态
  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      _startRecording();
    } else {
      _stopRecording();
    }
  }

  /// 开始记录
  void _startRecording() {
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final sensorDataProvider = Provider.of<SensorDataProvider>(
        context,
        listen: false,
      );
      final value =
          sensorDataProvider.latestData?.value ??
          (20.0 + (DateTime.now().millisecondsSinceEpoch % 1000) / 100); // 模拟数据

      final record = SensorRecord(timestamp: DateTime.now(), value: value);

      setState(() {
        _records.add(record);
      });

      _saveRecords();
    });
  }

  /// 停止记录
  void _stopRecording() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  /// 清除所有记录
  void _clearAllRecords() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除所有记录数据吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _records.clear();
              });
              _saveRecords();
              Navigator.pop(context);
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// 格式化时间戳
  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.month.toString().padLeft(2, '0')}-'
        '${timestamp.day.toString().padLeft(2, '0')} '
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }

  /// 加载记录数据
  void _loadRecords() {
    // 记录数据在内存中管理，应用重启后会清空
  }

  /// 保存记录数据
  void _saveRecords() {
    // 记录数据在内存中管理，应用重启后会清空
  }

  /// 导出CSV文件
  void _exportToCSV() async {
    if (_records.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('没有数据可导出'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // 生成CSV内容
      final csvContent = _generateCSVContent();

      // 显示CSV内容对话框（简化版本，不需要文件系统权限）
      _showCSVDialog(csvContent);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导出失败: $e'), backgroundColor: Colors.red),
      );
    }
  }

  /// 生成CSV内容
  String _generateCSVContent() {
    final buffer = StringBuffer();

    // CSV头部
    buffer.writeln('序号,时间,传感器数据');

    // CSV数据行
    for (int i = 0; i < _records.length; i++) {
      final record = _records[i];
      final timestamp = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(record.timestamp);
      buffer.writeln('${i + 1},$timestamp,${record.value.toStringAsFixed(2)}');
    }

    return buffer.toString();
  }

  /// 显示CSV内容对话框
  void _showCSVDialog(String csvContent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CSV数据'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: SelectableText(
              csvContent,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
          TextButton(
            onPressed: () {
              // 复制到剪贴板
              _copyToClipboard(csvContent);
              Navigator.pop(context);
            },
            child: const Text('复制'),
          ),
        ],
      ),
    );
  }

  /// 复制到剪贴板
  void _copyToClipboard(String text) {
    // 这里可以使用 Clipboard.setData，但需要导入 flutter/services
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CSV数据已显示，可手动复制'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

/// 通用传感器记录数据模型
class SensorRecord {
  final DateTime timestamp;
  final double value;

  SensorRecord({required this.timestamp, required this.value});

  Map<String, dynamic> toJson() {
    return {'timestamp': timestamp.millisecondsSinceEpoch, 'value': value};
  }

  factory SensorRecord.fromJson(Map<String, dynamic> json) {
    return SensorRecord(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      value: json['value'].toDouble(),
    );
  }
}
