// ignore_for_file: unnecessary_string_interpolations

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/num_pad.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../shared/services/history_service.dart';

/// Standard calculator with expression display, live result preview,
/// history drawer, and full operator support.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';
  bool _hasResult = false;
  final _historyService = HistoryService();

  void _onKeyPressed(String key) {
    setState(() {
      if (key == '( )') {
        int openCount = _expression.split('(').length - 1;
        int closeCount = _expression.split(')').length - 1;
        if (openCount == closeCount ||
            _expression.isEmpty ||
            _expression.endsWith('(') ||
            _expression.endsWith(' ')) {
          key = '(';
        } else {
          key = ')';
        }
      }

      if (_hasResult && _isDigit(key)) {
        _expression = key;
        _result = '';
        _hasResult = false;
      } else if (_hasResult && (_isOperator(key) || key == '%')) {
        _hasResult = false;
        _expression += (key == '%' ? '%' : ' $key ');
        _result = '';
      } else {
        if (key == '.') {
          final lastSegment = _getLastNumberSegment();
          if (lastSegment.contains('.')) return;
          _expression += key;
        } else if (key == '%') {
          _expression += '%';
        } else if (_isOperator(key)) {
          _expression += ' $key ';
        } else {
          _expression += key;
        }
      }
      _updatePreview();
    });
  }

  void _onBackspace() {
    if (_expression.isEmpty) return;
    setState(() {
      if (_expression.endsWith(' ')) {
        _expression = _expression.substring(0, _expression.length - 3);
      } else {
        _expression = _expression.substring(0, _expression.length - 1);
      }
      _updatePreview();
    });
  }

  void _onClear() {
    setState(() {
      _expression = '';
      _result = '';
      _hasResult = false;
    });
  }

  void _onEquals() {
    if (_expression.isEmpty) return;
    final result = _evaluate(_expression);
    if (result != null) {
      _historyService.add(
        calculatorType: 'standard',
        expression: _expression,
        result: NumberFormatter.formatDisplay(result),
      );
      setState(() {
        _result = '';
        _expression = NumberFormatter.formatDisplay(result);
        _hasResult = true;
      });
    }
  }

  void _updatePreview() {
    final result = _evaluate(_expression);
    _result = result != null ? '${NumberFormatter.formatDisplay(result)}' : '';
  }

  double? _evaluate(String expr) {
    try {
      var sanitized = expr.replaceAll(',', '');
      if (sanitized.isEmpty) return null;
      // Simple expression evaluation
      return _parseExpression(sanitized);
    } catch (_) {
      return null;
    }
  }

  /// Simple recursive descent parser for math expressions.
  double? _parseExpression(String s) {
    try {
      final parser = _ExprParser(s);
      final result = parser.parseExpr();
      if (result.isNaN || result.isInfinite) return null;
      return result;
    } catch (_) {
      return null;
    }
  }

  String _getLastNumberSegment() {
    final ops = ['+', '−', '×', '÷', '^', '(', ')', ' '];
    var lastIdx = -1;
    for (final op in ops) {
      final idx = _expression.lastIndexOf(op);
      if (idx > lastIdx) lastIdx = idx;
    }
    return lastIdx < 0 ? _expression : _expression.substring(lastIdx + 1);
  }

  bool _isDigit(String s) => RegExp(r'^\d+$').hasMatch(s);
  bool _isOperator(String s) => ['+', '−', '×', '÷', '^'].contains(s);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Calculator'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => _showHistory(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Display ──
          Expanded(
            child: Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.30,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.topRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Expression
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text.rich(
                      TextSpan(children: _buildExpressionSpans()),
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  if (_expression.isEmpty)
                    Text(
                      '',
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Result preview
                  Text(
                    _result,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Tool Bar (Above Numpad) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.more_horiz_rounded),
                      color: theme.colorScheme.primary,
                      iconSize: 40,
                      onPressed: () => _showScientificFunctions(context),
                    ),
                    const SizedBox(width: 50),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_up_rounded),
                      color: theme.colorScheme.primary,
                      iconSize: 40,
                      onPressed: () => _onKeyPressed('^'),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _onBackspace,
                  onLongPress: _onClear,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.backspace_rounded,
                      color: theme.colorScheme.primary,
                      size: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Numpad ──
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: NumPad(
                showOperators: true,
                onKeyPressed: _onKeyPressed,
                onClear: _onClear,
                onEquals: _onEquals,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildExpressionSpans() {
    final operators = ['+', '−', '×', '÷', '%', '^', '(', ')'];
    final spans = <TextSpan>[];
    var current = '';
    for (var i = 0; i < _expression.length; i++) {
      final ch = _expression[i];
      if (operators.contains(ch)) {
        if (current.isNotEmpty) {
          spans.add(TextSpan(text: current));
          current = '';
        }
        spans.add(
          TextSpan(
            text: ch == '(' || ch == ')' || ch == '%' ? ch : ' $ch ',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        );
      } else {
        current += ch;
      }
    }
    if (current.isNotEmpty) spans.add(TextSpan(text: current));
    return spans;
  }

  void _showHistory(BuildContext context) {
    final entries = _historyService.getAll('standard');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1C1C1E)
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.85,
        minChildSize: 0.3,
        expand: false,
        builder: (ctx, controller) {
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.history_rounded,
                    size: 48,
                    color: Color(0xFF8E8E93),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No calculations yet',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            controller: controller,
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final e = entries[i];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  e.expression,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
                subtitle: Text(
                  e.result,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _expression = e.result.replaceAll(',', '');
                    _hasResult = true;
                    _result = '';
                  });
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showScientificFunctions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
    final cardColor = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final textColor = Theme.of(context).colorScheme.primary;

    final functions = [
      ['π', 'e', 'φ'],
      ['log', 'ln', 'log₂'],
      ['√', '³√', '|x|'],
      ['sin', 'cos', 'tan'],
      ['sin⁻¹', 'cos⁻¹', 'tan⁻¹'],
      ['sinh', 'cosh', 'tanh'],
      ['sinh⁻¹', 'cosh⁻¹', 'tanh⁻¹'],
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.sizeOf(context).height * 0.65,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF333333),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              width: double.infinity,
              child: Text(
                'Scientific functions',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: functions.map((row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: row.map((func) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                _onScientificFunctionSelected(func);
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  func,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
            SafeArea(
              top: false,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: cardColor,
                  alignment: Alignment.center,
                  child: Text(
                    'CANCEL',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onScientificFunctionSelected(String func) {
    setState(() {
      if (['π', 'e', 'φ'].contains(func)) {
        _expression += func;
      } else if (func == '|x|') {
        _expression += 'abs(';
      } else {
        _expression += '$func(';
      }
      _updatePreview();
    });
  }
}

/// Simple recursive descent expression parser.
class _ExprParser {
  final String input;
  int pos = 0;

  _ExprParser(this.input);

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
      double exponent = parsePower(); // right associative
      result = math.pow(result, exponent).toDouble();
    }
    return result;
  }

  double parseBase() {
    _skipWhitespace();
    if (pos >= input.length) return 0;

    if (_match('-') || _match('−')) {
      return -parseBase();
    }
    if (_match('+')) {
      return parseBase();
    }
    if (_match('(')) {
      double result = parseExpr();
      _match(')');
      return result;
    }

    if (_match('π')) return math.pi;
    if (_match('e')) return math.e;
    if (_match('φ')) return (1 + math.sqrt(5)) / 2;

    if (_match('sin⁻¹(')) {
      double r = math.asin(parseExpr());
      _match(')');
      return r;
    }
    if (_match('cos⁻¹(')) {
      double r = math.acos(parseExpr());
      _match(')');
      return r;
    }
    if (_match('tan⁻¹(')) {
      double r = math.atan(parseExpr());
      _match(')');
      return r;
    }
    if (_match('sinh⁻¹(')) {
      double x = parseExpr();
      double r = math.log(x + math.sqrt(x * x + 1));
      _match(')');
      return r;
    }
    if (_match('cosh⁻¹(')) {
      double x = parseExpr();
      double r = math.log(x + math.sqrt(x * x - 1));
      _match(')');
      return r;
    }
    if (_match('tanh⁻¹(')) {
      double x = parseExpr();
      double r = 0.5 * math.log((1 + x) / (1 - x));
      _match(')');
      return r;
    }

    if (_match('sinh(')) {
      double x = parseExpr();
      double r = (math.exp(x) - math.exp(-x)) / 2;
      _match(')');
      return r;
    }
    if (_match('cosh(')) {
      double x = parseExpr();
      double r = (math.exp(x) + math.exp(-x)) / 2;
      _match(')');
      return r;
    }
    if (_match('tanh(')) {
      double x = parseExpr();
      double r = (math.exp(x) - math.exp(-x)) / (math.exp(x) + math.exp(-x));
      _match(')');
      return r;
    }

    if (_match('sin(')) {
      double r = math.sin(parseExpr());
      _match(')');
      return r;
    }
    if (_match('cos(')) {
      double r = math.cos(parseExpr());
      _match(')');
      return r;
    }
    if (_match('tan(')) {
      double r = math.tan(parseExpr());
      _match(')');
      return r;
    }

    if (_match('log₂(')) {
      double r = math.log(parseExpr()) / math.ln2;
      _match(')');
      return r;
    }
    if (_match('log(')) {
      double r = math.log(parseExpr()) / math.ln10;
      _match(')');
      return r;
    }
    if (_match('ln(')) {
      double r = math.log(parseExpr());
      _match(')');
      return r;
    }

    if (_match('√(')) {
      double r = math.sqrt(parseExpr());
      _match(')');
      return r;
    }
    if (_match('³√(')) {
      double r = math.pow(parseExpr(), 1 / 3).toDouble();
      _match(')');
      return r;
    }
    if (_match('abs(')) {
      double r = parseExpr().abs();
      _match(')');
      return r;
    }

    return parseNumber();
  }

  double parseNumber() {
    _skipWhitespace();
    final start = pos;
    while (pos < input.length && (input[pos].contains(RegExp(r'[\d.]')))) {
      pos++;
    }
    if (start == pos) return 0;
    return double.tryParse(input.substring(start, pos)) ?? 0;
  }
}
