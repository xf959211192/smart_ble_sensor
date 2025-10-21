import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../models/models.dart';

/// Thrown when CSV export fails.
class CsvExportException implements Exception {
  const CsvExportException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() =>
      cause == null ? 'CsvExportException: $message' : 'CsvExportException: $message ($cause)';
}

/// CSV export facade for sensor recordings.
class CsvExportService {
  static final CsvExportService _instance = CsvExportService._internal();
  factory CsvExportService() => _instance;
  CsvExportService._internal();

  /// Exports [records] to a CSV file and returns the created [File].
  ///
  /// If [directory] is omitted the application documents directory will be used.
  /// A custom [fileName] can be supplied (without path separators). When omitted
  /// a timestamp-based name is generated.
  Future<File> exportSensorRecords(
    List<SensorRecord> records, {
    Directory? directory,
    String? fileName,
    List<String>? orderedCharacteristicUuids,
  }) async {
    if (records.isEmpty) {
      throw const CsvExportException('没有数据可导出');
    }

    try {
      final Directory targetDirectory = await _resolveDirectory(directory);
      final String resolvedFileName = _resolveFileName(fileName);
      final File file = _composeFile(targetDirectory, resolvedFileName);

      final String csvContent = buildCsvContent(
        records,
        orderedCharacteristicUuids: orderedCharacteristicUuids,
      );
      await file.writeAsString(csvContent);
      return file;
    } catch (error) {
      if (error is CsvExportException) rethrow;
      throw CsvExportException('导出CSV文件失败', error);
    }
  }

  /// Generates CSV string content for [records].
  ///
  /// When [orderedCharacteristicUuids] is provided, those UUIDs (normalised) will
  /// define the column order. UUIDs not listed will be appended afterwards.
  String buildCsvContent(
    List<SensorRecord> records, {
    List<String>? orderedCharacteristicUuids,
  }) {
    final List<List<dynamic>> data = _prepareCsvData(
      records,
      orderedCharacteristicUuids: orderedCharacteristicUuids,
    );
    return const ListToCsvConverter().convert(data);
  }

  /// Collects all characteristic UUIDs present in the [records], returned in
  /// alphabetical order.
  List<String> collectCharacteristicUuids(List<SensorRecord> records) {
    final Set<String> uuidSet = <String>{};
    for (final SensorRecord record in records) {
      uuidSet.addAll(record.valuesByUuid.keys);
    }
    final List<String> ordered = uuidSet.toList()..sort();
    return ordered;
  }

  Future<Directory> defaultExportDirectory() async {
    return getApplicationDocumentsDirectory();
  }

  File _composeFile(Directory directory, String fileName) {
    final String dirPath = directory.path;
    final String separator =
        dirPath.endsWith(Platform.pathSeparator) ? '' : Platform.pathSeparator;
    return File('$dirPath$separator$fileName');
  }

  Future<Directory> _resolveDirectory(Directory? directory) async {
    if (directory != null) {
      if (!await directory.exists()) {
        try {
          await directory.create(recursive: true);
        } catch (error) {
          throw CsvExportException('无法创建导出目录: ${directory.path}', error);
        }
      }
      return directory;
    }
    return defaultExportDirectory();
  }

  String _resolveFileName(String? fileName) {
    final String trimmed = fileName?.trim() ?? '';
    if (trimmed.isNotEmpty) {
      if (trimmed.contains(RegExp(r'[\/\\]'))) {
        throw const CsvExportException('文件名中不能包含路径分隔符');
      }
      return trimmed.endsWith('.csv') ? trimmed : '$trimmed.csv';
    }
    final String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return 'sensor_data_$timestamp.csv';
  }

  List<List<dynamic>> _prepareCsvData(
    List<SensorRecord> records, {
    List<String>? orderedCharacteristicUuids,
  }) {
    final List<String> orderedUuids = _buildUuidOrder(
      records,
      orderedCharacteristicUuids,
    );

    final List<List<dynamic>> rows = <List<dynamic>>[
      <dynamic>[
        '序号',
        '时间',
        ...orderedUuids.map((uuid) => uuid.toUpperCase()),
      ],
    ];

    for (int i = 0; i < records.length; i++) {
      final SensorRecord record = records[i];
      final String timestamp =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(record.timestamp.toLocal());

      final List<dynamic> row = <dynamic>[i + 1, timestamp];
      for (final String uuid in orderedUuids) {
        row.add(_formatValue(record.valueForUuid(uuid)));
      }
      rows.add(row);
    }

    return rows;
  }

  List<String> _buildUuidOrder(
    List<SensorRecord> records,
    List<String>? preferredOrder,
  ) {
    final List<String> preferred = preferredOrder
            ?.map((uuid) => uuid.trim().toLowerCase())
            .where((uuid) => uuid.isNotEmpty)
            .toList() ??
        <String>[];

    final Set<String> collected = <String>{};
    for (final SensorRecord record in records) {
      collected.addAll(record.valuesByUuid.keys);
    }

    final List<String> remaining = collected
        .where((uuid) => !preferred.contains(uuid))
        .toList()
      ..sort();

    return <String>[...preferred, ...remaining];
  }

  String _formatValue(double? value) {
    if (value == null) return '';
    return value.toStringAsFixed(2);
  }

  Future<bool> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<int> getFileSize(File file) async {
    try {
      if (await file.exists()) {
        return file.length();
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

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
