import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatIndian(num n) {
    if (n == 0) return '0';
    final isNegative = n < 0;
    final abs = n.abs();
    final str = abs is int
        ? abs.toString()
        : (() {
            final s = abs.toString();
            if (s.contains('e') || s.contains('E')) {
              return _trimTrailingZeros(abs.toStringAsFixed(10));
            }
            return s;
          })();

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

  static String formatInternational(num n) {
    if (n is int) {
      return NumberFormat('#,###').format(n);
    }
    final formatted = NumberFormat('#,##0.##########').format(n);
    return formatted;
  }

  static String format(num n, {bool indian = true}) {
    return indian ? formatIndian(n) : formatInternational(n);
  }

  static String formatFixed(num n, int decimals, {bool indian = true}) {
    if (n.isNaN || n.isInfinite) return n.toString();
    final fixedStr = n.toStringAsFixed(decimals);
    final parts = fixedStr.split('.');
    final intStr = parts[0];
    final decStr = parts.length > 1 ? parts[1] : '';

    final isNegative = n < 0 || (n == 0 && fixedStr.startsWith('-'));
    final absIntStr = intStr.replaceAll('-', '');
    final absIntVal = int.tryParse(absIntStr) ?? 0;

    String formattedInt;
    if (indian) {
      formattedInt = formatIndian(absIntVal);
    } else {
      formattedInt = formatInternational(absIntVal);
    }

    if (decimals == 0) {
      return '${isNegative ? '-' : ''}$formattedInt';
    }
    return '${isNegative ? '-' : ''}$formattedInt.$decStr';
  }

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

  static String formatDisplay(double n) {
    if (n == n.toInt().toDouble()) {
      return formatIndian(n.toInt());
    }
    return formatIndian(n);
  }
}
