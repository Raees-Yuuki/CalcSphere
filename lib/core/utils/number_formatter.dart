import 'package:intl/intl.dart';

/// Number formatting utilities for CalcSphere.
class NumberFormatter {
  /// Format number in Indian system: 5646943131 → "56,46,43,131"
  static String formatIndian(num n) {
    if (n == 0) return '0';
    final isNegative = n < 0;
    final abs = n.abs();
    final str = abs is int
        ? abs.toString()
        : _trimTrailingZeros(abs.toStringAsFixed(10));

    final parts = str.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '';

    if (intPart.length <= 3) return '${isNegative ? '-' : ''}$intPart$decPart';

    final last3 = intPart.substring(intPart.length - 3);
    var remaining = intPart.substring(0, intPart.length - 3);
    final groups = <String>[];

    while (remaining.length > 2) {
      groups.insert(0, remaining.substring(remaining.length - 2));
      remaining = remaining.substring(0, remaining.length - 2);
    }
    if (remaining.isNotEmpty) groups.insert(0, remaining);

    return '${isNegative ? '-' : ''}${groups.join(',')},${last3}$decPart';
  }

  /// Format number in international system: 5646943131 → "5,646,943,131"
  static String formatInternational(num n) {
    if (n is int) {
      return NumberFormat('#,###').format(n);
    }
    final formatted = NumberFormat('#,##0.##########').format(n);
    return formatted;
  }

  /// Format based on user preference.
  static String format(num n, {bool indian = true}) {
    return indian ? formatIndian(n) : formatInternational(n);
  }

  /// Format with fixed decimal places.
  static String formatFixed(num n, int decimals, {bool indian = true}) {
    final rounded = double.parse(n.toStringAsFixed(decimals));
    final formatted = indian
        ? formatIndian(rounded)
        : formatInternational(rounded);
    // Ensure decimal places
    if (!formatted.contains('.')) {
      return '$formatted.${List.filled(decimals, '0').join()}';
    }
    final decPart = formatted.split('.')[1];
    if (decPart.length < decimals) {
      return '$formatted${'0' * (decimals - decPart.length)}';
    }
    return formatted;
  }

  /// Parse a formatted string back to num.
  static num? parse(String s) {
    final cleaned = s.replaceAll(',', '').replaceAll(' ', '');
    return num.tryParse(cleaned);
  }

  static String _trimTrailingZeros(String s) {
    if (!s.contains('.')) return s;
    var result = s;
    while (result.endsWith('0')) {
      result = result.substring(0, result.length - 1);
    }
    if (result.endsWith('.')) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }

  /// Format a display string for the calculator (no trailing zeros).
  static String formatDisplay(double n) {
    if (n == n.toInt().toDouble()) {
      return formatIndian(n.toInt());
    }
    return formatIndian(n);
  }
}
