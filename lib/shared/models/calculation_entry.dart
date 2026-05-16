/// A single calculation history entry.
class CalculationEntry {
  final String id;
  final String calculatorType;
  final String expression;
  final String result;
  final DateTime timestamp;

  const CalculationEntry({
    required this.id,
    required this.calculatorType,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'calculatorType': calculatorType,
    'expression': expression,
    'result': result,
    'timestamp': timestamp.toIso8601String(),
  };

  factory CalculationEntry.fromMap(Map<dynamic, dynamic> map) {
    return CalculationEntry(
      id: map['id'] as String,
      calculatorType: map['calculatorType'] as String,
      expression: map['expression'] as String,
      result: map['result'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
