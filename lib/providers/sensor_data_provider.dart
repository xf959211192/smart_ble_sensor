import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

/// 通用传感器数据状态提供者
class SensorDataProvider extends ChangeNotifier {
  final BluetoothService _bluetoothService = BluetoothService();
  StreamSubscription<SensorData>? _sensorDataSubscription;

  // 通用数据存储
  final Queue<SensorData> _sensorData = Queue<SensorData>();

  // 最大数据点数量（用于图表显示）
  static const int maxDataPoints = 50;

  // 当前值
  SensorData? _latestData;

  // 数据接收状态
  bool _isReceivingData = false;
  DateTime? _lastDataTime;

  // Getters
  List<SensorData> get sensorData => _sensorData.toList();
  SensorData? get latestData => _latestData;

  bool get isReceivingData => _isReceivingData;
  DateTime? get lastDataTime => _lastDataTime;

  SensorDataProvider() {
    _initializeSensorDataService();
  }

  /// 初始化传感器数据服务
  void _initializeSensorDataService() {
    _sensorDataSubscription = _bluetoothService.sensorDataStream.listen(
      (SensorData data) {
        addData(data);
      },
      onError: (error) {
        debugPrint('传感器数据接收错误: $error');
      },
    );
  }

  /// 添加传感器数据
  void addData(SensorData data) {
    _isReceivingData = true;
    _lastDataTime = data.timestamp;
    _latestData = data;

    // 添加到数据列表
    _sensorData.addLast(data);

    // 限制数据点数量
    while (_sensorData.length > maxDataPoints) {
      _sensorData.removeFirst();
    }

    notifyListeners();
  }

  /// 清除所有数据
  void clearAllData() {
    _sensorData.clear();
    _latestData = null;
    _isReceivingData = false;
    _lastDataTime = null;
    notifyListeners();
  }

  /// 获取数据点数量
  int get dataCount => _sensorData.length;

  /// 检查是否有数据
  bool get hasData => _sensorData.isNotEmpty;

  @override
  void dispose() {
    _sensorDataSubscription?.cancel();
    super.dispose();
  }
}
