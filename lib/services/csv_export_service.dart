import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../screens/home_screen.dart'; // 导入SensorRecord

/// CSV导出服务
class CsvExportService {
  static final CsvExportService _instance = CsvExportService._internal();
  factory CsvExportService() => _instance;
  CsvExportService._internal();

  /// 导出传感器记录到CSV文件
  Future<String> exportSensorRecords(List<SensorRecord> records) async {
    if (records.isEmpty) {
      throw Exception('没有数据可导出');
    }

    try {
      // 获取应用文档目录
      final directory = await getApplicationDocumentsDirectory();
      
      // 创建文件名（包含时间戳）
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'sensor_data_$timestamp.csv';
      final filePath = '${directory.path}/$fileName';

      // 准备CSV数据
      final csvData = _prepareCsvData(records);
      
      // 转换为CSV格式
      final csvString = const ListToCsvConverter().convert(csvData);
      
      // 写入文件
      final file = File(filePath);
      await file.writeAsString(csvString);
      
      return filePath;
    } catch (e) {
      throw Exception('导出CSV文件失败: $e');
    }
  }

  /// 准备CSV数据
  List<List<dynamic>> _prepareCsvData(List<SensorRecord> records) {
    final csvData = <List<dynamic>>[];
    
    // 添加表头
    csvData.add(['序号', '时间', '传感器数据']);
    
    // 添加数据行
    for (int i = 0; i < records.length; i++) {
      final record = records[i];
      final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(record.timestamp);
      csvData.add([
        i + 1,
        timestamp,
        record.value.toStringAsFixed(2),
      ]);
    }
    
    return csvData;
  }

  /// 获取导出文件的默认目录
  Future<String> getExportDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 检查文件是否存在
  Future<bool> fileExists(String filePath) async {
    final file = File(filePath);
    return await file.exists();
  }

  /// 删除导出的文件
  Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 获取文件大小
  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// 格式化文件大小
  String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}
