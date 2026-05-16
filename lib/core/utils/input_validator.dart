/// Input validation utilities for all CalcSphere calculators.
class InputValidator {
  /// Max digits allowed per input field.
  static const int maxDigits = 15;

  /// Block invalid characters — only digits and one decimal point.
  static String sanitize(String input) {
    String cleaned = input.replaceAll(RegExp(r'[^\d.]'), '');
    final parts = cleaned.split('.');
    if (parts.length > 2) cleaned = '${parts[0]}.${parts[1]}';
    if (cleaned.replaceAll('.', '').length > maxDigits) return input;
    return cleaned;
  }

  /// Guard against division by zero.
  static bool isDivisionByZero(num a, num b) => b == 0;

  /// Guard against overflow.
  static bool isOverflow(num value) =>
      value.isInfinite || value.isNaN || value.abs() > 1e15;

  /// Validate percentage (0–100 only).
  static bool isValidPercent(num value) => value >= 0 && value <= 100;

  /// Validate positive-only fields (loan, fuel, etc.).
  static bool isPositive(num value) => value > 0;

  /// Validate non-negative fields.
  static bool isNonNegative(num value) => value >= 0;

  /// Check if string is a valid number.
  static bool isValidNumber(String s) {
    if (s.isEmpty) return false;
    return num.tryParse(s.replaceAll(',', '')) != null;
  }

  /// Parse string to double safely.
  static double? tryParseDouble(String s) {
    if (s.isEmpty) return null;
    return double.tryParse(s.replaceAll(',', ''));
  }
}
