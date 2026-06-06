import 'dart:math' as math;

class ExprParser {
  final String input;
  int pos = 0;

  ExprParser(this.input);

  static double? evaluate(String expr) {
    try {
      final sanitized = expr.replaceAll(',', '');
      if (sanitized.isEmpty) return null;
      final parser = ExprParser(sanitized);
      final result = parser.parseExpr();
      if (result.isNaN || result.isInfinite) return null;
      return result;
    } catch (_) {
      return null;
    }
  }

  void _skipWhitespace() {
    while (pos < input.length && input[pos] == ' ') pos++;
  }

  bool _match(String s) {
    _skipWhitespace();
    if (pos + s.length <= input.length &&
        input.substring(pos, pos + s.length) == s) {
      pos += s.length;
      return true;
    }
    return false;
  }

  double parseExpr() {
    _skipWhitespace();
    if (pos >= input.length) return 0;
    var result = parseTerm();
    while (pos < input.length) {
      _skipWhitespace();
      if (_match('+')) {
        result += parseTerm();
      } else if (_match('-') || _match('−')) {
        result -= parseTerm();
      } else {
        break;
      }
    }
    return result;
  }

  double parseTerm() {
    var result = parseFactor();
    while (pos < input.length) {
      _skipWhitespace();
      if (_match('*') || _match('×')) {
        result *= parseFactor();
      } else if (_match('/') || _match('÷')) {
        final divisor = parseFactor();
        if (divisor == 0) return double.nan;
        result /= divisor;
      } else {
        break;
      }
    }
    return result;
  }

  double parseFactor() {
    double result = parsePower();
    while (pos < input.length) {
      _skipWhitespace();
      if (_match('%')) {
        result /= 100;
      } else {
        break;
      }
    }
    return result;
  }

  double parsePower() {
    double result = parseBase();
    _skipWhitespace();
    if (_match('^')) {
      final exponent = parsePower();
      result = math.pow(result, exponent).toDouble();
    }
    return result;
  }

  double parseBase() {
    _skipWhitespace();
    if (pos >= input.length) return 0;

    if (_match('-') || _match('−')) return -parseBase();
    if (_match('+')) return parseBase();

    if (_match('(')) {
      final result = parseExpr();
      _match(')');
      return result;
    }

    if (_match('π')) return math.pi;
    if (_match('e')) return math.e;
    if (_match('φ')) return (1 + math.sqrt(5)) / 2;

    if (_match('sinh⁻¹(')) {
      final x = parseExpr();
      _match(')');
      return math.log(x + math.sqrt(x * x + 1));
    }
    if (_match('cosh⁻¹(')) {
      final x = parseExpr();
      _match(')');
      return math.log(x + math.sqrt(x * x - 1));
    }
    if (_match('tanh⁻¹(')) {
      final x = parseExpr();
      _match(')');
      return 0.5 * math.log((1 + x) / (1 - x));
    }

    if (_match('sinh(')) {
      final x = parseExpr();
      _match(')');
      return (math.exp(x) - math.exp(-x)) / 2;
    }
    if (_match('cosh(')) {
      final x = parseExpr();
      _match(')');
      return (math.exp(x) + math.exp(-x)) / 2;
    }
    if (_match('tanh(')) {
      final x = parseExpr();
      _match(')');
      return (math.exp(x) - math.exp(-x)) / (math.exp(x) + math.exp(-x));
    }

    if (_match('sin⁻¹(')) {
      final r = math.asin(parseExpr());
      _match(')');
      return r;
    }
    if (_match('cos⁻¹(')) {
      final r = math.acos(parseExpr());
      _match(')');
      return r;
    }
    if (_match('tan⁻¹(')) {
      final r = math.atan(parseExpr());
      _match(')');
      return r;
    }

    if (_match('sin(')) {
      final r = math.sin(parseExpr());
      _match(')');
      return r;
    }
    if (_match('cos(')) {
      final r = math.cos(parseExpr());
      _match(')');
      return r;
    }
    if (_match('tan(')) {
      final r = math.tan(parseExpr());
      _match(')');
      return r;
    }

    if (_match('log₂(')) {
      final r = math.log(parseExpr()) / math.ln2;
      _match(')');
      return r;
    }
    if (_match('log(')) {
      final r = math.log(parseExpr()) / math.ln10;
      _match(')');
      return r;
    }
    if (_match('ln(')) {
      final r = math.log(parseExpr());
      _match(')');
      return r;
    }

    if (_match('³√(')) {
      final r = math.pow(parseExpr(), 1 / 3).toDouble();
      _match(')');
      return r;
    }
    if (_match('√(')) {
      final r = math.sqrt(parseExpr());
      _match(')');
      return r;
    }
    if (_match('abs(')) {
      final r = parseExpr().abs();
      _match(')');
      return r;
    }

    return parseNumber();
  }

  double parseNumber() {
    _skipWhitespace();
    final start = pos;
    while (pos < input.length && input[pos].contains(RegExp(r'[\d.]'))) {
      pos++;
    }
    if (start == pos) return 0;
    return double.tryParse(input.substring(start, pos)) ?? 0;
  }
}
