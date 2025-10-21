import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:smartblesensor/models/models.dart';
import 'package:smartblesensor/services/csv_export_service.dart';

void main() {
  group('CsvExportService', () {
    late CsvExportService service;
    late List<SensorRecord> records;

    setUp(() {
      service = CsvExportService();
      records = <SensorRecord>[
        SensorRecord(
          timestamp: DateTime.utc(2024, 1, 1, 12, 0, 0),
          valuesByUuid: {
            'uuid-a': 23.456,
            'uuid-b': 50.0,
          },
        ),
        SensorRecord(
          timestamp: DateTime.utc(2024, 1, 1, 12, 0, 5),
          valuesByUuid: {
            'uuid-b': 51.2,
            'uuid-c': 12.34,
          },
        ),
      ];
    });

    test('buildCsvContent respects provided UUID order', () {
      final String csv = service.buildCsvContent(
        records,
        orderedCharacteristicUuids: <String>['uuid-b', 'uuid-a'],
      );

      final List<String> lines = LineSplitter.split(csv).toList();
      expect(lines[0], '序号,时间,UUID-B,UUID-A,UUID-C');

      final List<String> cells1 = lines[1].split(',');
      final List<String> cells2 = lines[2].split(',');

      expect(cells1[0], '1');
      expect(cells1[2], '50.00');
      expect(cells1[3], '23.46');
      expect(
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(cells1[1]),
        records.first.timestamp.toLocal(),
      );

      expect(cells2[0], '2');
      expect(cells2[2], '51.20');
      expect(cells2[3], '');
      expect(cells2[4], '12.34');
    });

    test('exportSensorRecords writes file to provided directory', () async {
      final Directory tempDir =
          await Directory.systemTemp.createTemp('csv_export_test_');
      addTearDown(() async {
        if (await tempDir.exists()) await tempDir.delete(recursive: true);
      });

      final File file = await service.exportSensorRecords(
        records,
        directory: tempDir,
        fileName: 'test_records.csv',
        orderedCharacteristicUuids: <String>['uuid-a', 'uuid-b', 'uuid-c'],
      );

      expect(await file.exists(), isTrue);
      final String content = await file.readAsString();
      expect(content, contains('UUID-A'));
      expect(content, contains('UUID-B'));
      expect(content, contains('UUID-C'));
    });
  });
}
