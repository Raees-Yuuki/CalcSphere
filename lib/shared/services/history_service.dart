import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/calculation_entry.dart';

/// Local history storage using Hive — last 50 entries per calculator type.
class HistoryService {
  static const _boxName = 'history';
  static const _maxEntries = 50;
  static const _uuid = Uuid();

  Box get _box => Hive.box(_boxName);

  /// Add a new calculation entry.
  Future<void> add({
    required String calculatorType,
    required String expression,
    required String result,
  }) async {
    final entry = CalculationEntry(
      id: _uuid.v4(),
      calculatorType: calculatorType,
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
    );

    List<Map> existing = _getRawList(calculatorType);
    existing.insert(0, entry.toMap());
    if (existing.length > _maxEntries) {
      existing = existing.sublist(0, _maxEntries);
    }
    await _box.put(calculatorType, existing);
  }

  /// Get all history entries for a calculator type.
  List<CalculationEntry> getAll(String calculatorType) {
    return _getRawList(
      calculatorType,
    ).map((m) => CalculationEntry.fromMap(m)).toList();
  }

  /// Clear history for a specific calculator type.
  Future<void> clear(String calculatorType) async {
    await _box.put(calculatorType, []);
  }

  /// Clear all history.
  Future<void> clearAll() async {
    await _box.clear();
  }

  /// Export history as CSV string.
  String exportCsv(String calculatorType) {
    final entries = getAll(calculatorType);
    final buffer = StringBuffer('Calculator,Expression,Result,Timestamp\n');
    for (final e in entries) {
      buffer.writeln(
        '${e.calculatorType},"${e.expression}","${e.result}",${e.timestamp.toIso8601String()}',
      );
    }
    return buffer.toString();
  }

  List<Map> _getRawList(String calculatorType) {
    final raw = _box.get(calculatorType, defaultValue: []);
    if (raw is List) {
      return raw.cast<Map>();
    }
    return [];
  }
}
