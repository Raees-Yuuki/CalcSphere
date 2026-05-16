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
      if (_hasResult && _isDigit(key)) {
        _expression = key;
        _result = '';
        _hasResult = false;
      } else if (_hasResult && _isOperator(key)) {
        _hasResult = false;
        _expression += ' $key ';
        _result = '';
      } else {
        if (key == '.') {
          final lastSegment = _getLastNumberSegment();
          if (lastSegment.contains('.')) return;
        }
        _expression += key;
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
        expression: _formatExpression(_expression),
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
      var sanitized = expr
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-')
          .replaceAll(',', '')
          .replaceAll(' ', '');
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

  String _formatExpression(String expr) {
    return expr.replaceAll('*', '×').replaceAll('/', '÷');
  }

  String _getLastNumberSegment() {
    final ops = ['+', '−', '×', '÷', ' '];
    var lastIdx = -1;
    for (final op in ops) {
      final idx = _expression.lastIndexOf(op);
      if (idx > lastIdx) lastIdx = idx;
    }
    return lastIdx < 0 ? _expression : _expression.substring(lastIdx + 1);
  }

  bool _isDigit(String s) => RegExp(r'^\d$').hasMatch(s);
  bool _isOperator(String s) => ['+', '−', '×', '÷'].contains(s);

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
                onBackspace: _onBackspace,
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
            text: ' $ch ',
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
}

/// Simple recursive descent expression parser.
class _ExprParser {
  final String input;
  int pos = 0;

  _ExprParser(this.input);

  double parseExpr() {
    var result = parseTerm();
    while (pos < input.length) {
      if (input[pos] == '+') {
        pos++;
        result += parseTerm();
      } else if (input[pos] == '-') {
        pos++;
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
      if (input[pos] == '*') {
        pos++;
        result *= parseFactor();
      } else if (input[pos] == '/') {
        pos++;
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
    if (pos < input.length && input[pos] == '(') {
      pos++; // skip (
      final result = parseExpr();
      if (pos < input.length && input[pos] == ')') pos++; // skip )
      return result;
    }
    return parseNumber();
  }

  double parseNumber() {
    final start = pos;
    if (pos < input.length && input[pos] == '-') pos++;
    while (pos < input.length && (input[pos].contains(RegExp(r'[\d.]')))) {
      pos++;
    }
    if (start == pos) return 0;
    return double.tryParse(input.substring(start, pos)) ?? 0;
  }
}
