import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

/// Manages persistence of recorded sensor data snapshots.
///
/// Records are stored as a JSON array inside the application documents
/// directory so that they survive application restarts and can be exported.
class SensorRecordingService {
  SensorRecordingService({String? fileName})
    : _fileName = fileName ?? _defaultFileName;

  static const String _defaultFileName = 'sensor_records.json';

  final String _fileName;

  /// Loads all stored records from disk. Returns an empty list on failure.
  Future<List<SensorRecord>> loadRecords() async {
    try {
      final file = await _ensureRecordsFile();
      if (!await file.exists()) {
        return <SensorRecord>[];
      }

      final raw = await file.readAsString();
      if (raw.trim().isEmpty) {
        return <SensorRecord>[];
      }

      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return <SensorRecord>[];
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(SensorRecord.fromJson)
          .toList(growable: false);
    } catch (_) {
      return <SensorRecord>[];
    }
  }

  /// Persists the provided list of records, replacing any existing data.
  Future<bool> saveRecords(List<SensorRecord> records) async {
    try {
      final file = await _ensureRecordsFile(createIfMissing: true);
      final encoded = jsonEncode(
        records.map((record) => record.toJson()).toList(),
      );
      await file.writeAsString(encoded, flush: true);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Appends a record to the persisted collection.
  Future<bool> appendRecord(SensorRecord record) async {
    final List<SensorRecord> records = await loadRecords();
    return saveRecords(<SensorRecord>[...records, record]);
  }

  /// Removes all stored records.
  Future<bool> clear() async {
    try {
      final file = await _ensureRecordsFile();
      if (await file.exists()) {
        await file.writeAsString('[]', flush: true);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<File> _ensureRecordsFile({bool createIfMissing = false}) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');
    if (!await file.exists() && createIfMissing) {
      await file.create(recursive: true);
      await file.writeAsString('[]', flush: true);
    }
    return file;
  }
}
