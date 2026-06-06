class InputValidator {
  static const int maxDigits = 15;

  static String sanitize(String input) {
    String cleaned = input.replaceAll(RegExp(r'[^\d.]'), '');
    final parts = cleaned.split('.');
    if (parts.length > 2) cleaned = '${parts[0]}.${parts[1]}';
    if (cleaned.replaceAll('.', '').length > maxDigits) return input;
    return cleaned;
  }

  static bool isDivisionByZero(num a, num b) => b == 0;

  static bool isOverflow(num value) =>
      value.isInfinite || value.isNaN || value.abs() > 1e15;

  static bool isValidPercent(num value) => value >= 0 && value <= 100;

  static bool isPositive(num value) => value > 0;

  static bool isNonNegative(num value) => value >= 0;

  static bool isValidNumber(String s) {
    if (s.isEmpty) return false;
    return num.tryParse(s.replaceAll(',', '')) != null;
  }

  static double? tryParseDouble(String s) {
    if (s.isEmpty) return null;
    return double.tryParse(s.replaceAll(',', ''));
  }
}
