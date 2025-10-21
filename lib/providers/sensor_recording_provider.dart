import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

/// Provides reactive access to persisted sensor recordings.
class SensorRecordingProvider extends ChangeNotifier {
  SensorRecordingProvider({SensorRecordingService? service})
    : _service = service ?? SensorRecordingService();

  final SensorRecordingService _service;

  final List<SensorRecord> _records = <SensorRecord>[];
  bool _isLoading = false;
  bool _isSaving = false;

  List<SensorRecord> get records => List.unmodifiable(_records);
  bool get hasRecords => _records.isNotEmpty;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  /// Loads persisted records from disk.
  Future<void> loadRecords() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      final loaded = await _service.loadRecords();
      _records
        ..clear()
        ..addAll(loaded);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new record and persists the updated list.
  Future<bool> addRecord(SensorRecord record) async {
    _records.add(record);
    return _persistChanges();
  }

  /// Replaces existing records with the supplied list.
  Future<bool> replaceAll(List<SensorRecord> records) async {
    _records
      ..clear()
      ..addAll(records);
    return _persistChanges();
  }

  /// Clears all records from memory and disk.
  Future<bool> clearRecords() async {
    _records.clear();
    final success = await _service.clear();
    notifyListeners();
    return success;
  }

  /// Removes a record at the provided index.
  Future<bool> removeAt(int index) async {
    if (index < 0 || index >= _records.length) {
      return false;
    }
    _records.removeAt(index);
    return _persistChanges();
  }

  Future<bool> _persistChanges() async {
    _isSaving = true;
    notifyListeners();

    try {
      final success = await _service.saveRecords(_records);
      return success;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
