// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../../../../core/utils/expr_parser.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/utils/input_validator.dart';
import '../../../../shared/services/history_service.dart';

/// Custom [TextEditingController] that colours operator characters using the
/// theme's primary colour.  The underlying [text] stores expressions compactly
/// (no spaces around operators), so every stored character maps to exactly one
/// cursor-position unit — no offset arithmetic needed anywhere.
class ExpressionTextEditingController extends TextEditingController {
  static const _opChars = {'+', '−', '×', '÷', '^', '%', '(', ')'};

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final opStyle = (style ?? const TextStyle()).copyWith(
      color: Theme.of(context).colorScheme.primary,
    );
    final txt = value.text;
    if (txt.isEmpty) return TextSpan(style: style);

    final spans = <InlineSpan>[];
    final buf = StringBuffer();

    for (var i = 0; i < txt.length; i++) {
      final ch = txt[i];
      if (_opChars.contains(ch)) {
        if (buf.isNotEmpty) {
          spans.add(TextSpan(text: buf.toString(), style: style));
          buf.clear();
        }
        spans.add(TextSpan(text: ch, style: opStyle));
      } else {
        buf.write(ch);
      }
    }
    if (buf.isNotEmpty) spans.add(TextSpan(text: buf.toString(), style: style));
    return TextSpan(children: spans);
  }
}

class CalculatorController {
  CalculatorController() {
    expressionController = ExpressionTextEditingController();
    focusNode = FocusNode();
  }

  late final ExpressionTextEditingController expressionController;
  late final FocusNode focusNode;

  final ValueNotifier<String> resultNotifier = ValueNotifier('');
  final ValueNotifier<bool> hasResultNotifier = ValueNotifier(false);

  void Function(String)? onError;

  final _history = HistoryService();

  // ── Convenience accessors ──────────────────────────────────────────────────

  String get _text => expressionController.text;

  TextSelection get _sel {
    final s = expressionController.selection;
    return s.isValid ? s : TextSelection.collapsed(offset: _text.length);
  }

  int get _start => _sel.isCollapsed ? _sel.baseOffset : _sel.start;
  int get _end => _sel.isCollapsed ? _sel.baseOffset : _sel.end;
  bool get _hasSel => !_sel.isCollapsed;

  String get _before => _text.substring(0, _start);
  String get _after => _text.substring(_end);

  // ── Public API ─────────────────────────────────────────────────────────────

  void onKeyPressed(String key) {
    if (key == '( )') key = _resolveParen();

    // ── Post-result mode ──────────────────────────────────────────────────────
    if (hasResultNotifier.value) {
      if (_isDigit(key)) {
        _set(key, key.length);
        hasResultNotifier.value = false;
        resultNotifier.value = '';
        _preview();
        return;
      }
      if (_isBinOp(key) || key == '%') {
        // Strip display commas before continuing from result
        final raw = _text.replaceAll(',', '');
        if (raw != _text) _setRaw(raw, raw.length);
        hasResultNotifier.value = false;
        _insert(key);
        return;
      }
    }

    // ── Binary operator ───────────────────────────────────────────────────────
    if (_isBinOp(key)) {
      final b = _before;
      if (b.isNotEmpty && _isBinOp(b[b.length - 1])) {
        _replaceOp(key);
      } else if (!_canInsertOp()) {
        onError?.call('Enter a number first');
      } else {
        _insert(key);
      }
      return;
    }

    // ── Percent ───────────────────────────────────────────────────────────────
    if (key == '%') {
      if (!_canInsertOp()) {
        onError?.call('Enter a number first');
        return;
      }
      if (_before.endsWith('%')) return;
      _insert('%');
      return;
    }

    // ── Decimal ───────────────────────────────────────────────────────────────
    if (key == '.') {
      if (_operand().contains('.')) return;
      _insert('.');
      return;
    }

    // ── Digit ─────────────────────────────────────────────────────────────────
    if (_isDigit(key)) {
      final cur = _operandDigits();
      final add = key.length;

      if (cur >= InputValidator.maxDigits) {
        onError?.call('Max ${InputValidator.maxDigits} digits per number');
        return;
      }
      if (cur + add > InputValidator.maxDigits) {
        if (add == 2) {
          // '00' with only 1 slot → insert single '0'
          _autoMul();
          _insert('0');
          onError?.call('Max ${InputValidator.maxDigits} digits per number');
        } else {
          onError?.call('Max ${InputValidator.maxDigits} digits per number');
        }
        return;
      }
      _autoMul();
      _insert(key);
      return;
    }

    _insert(key);
  }

  void onBackspace() {
    if (_hasSel) {
      _set(_text.replaceRange(_sel.start, _sel.end, ''), _sel.start);
      return;
    }
    final pos = _start;
    if (pos == 0) return;
    _set(_text.substring(0, pos - 1) + _text.substring(pos), pos - 1);
  }

  void onClear() {
    expressionController.value = TextEditingValue.empty;
    resultNotifier.value = '';
    hasResultNotifier.value = false;
  }

  void onEquals() {
    if (_text.isEmpty) return;
    final result = _eval(_text);
    if (result != null) {
      final fmt = NumberFormatter.formatDisplay(result);
      _history.add(calculatorType: 'standard', expression: _text, result: fmt);
      _set(fmt, fmt.length);
      resultNotifier.value = '';
      hasResultNotifier.value = true;
    }
  }

  void onScientificFunctionSelected(String func) {
    // Exit result mode first, stripping display commas
    if (hasResultNotifier.value) {
      final raw = _text.replaceAll(',', '');
      if (raw != _text) _setRaw(raw, raw.length);
      hasResultNotifier.value = false;
    }

    final b = _before;
    if (b.isNotEmpty && RegExp(r'[\d)πeφ%]').hasMatch(b[b.length - 1])) {
      _insert('×');
    }

    const consts = {'π', 'e', 'φ'};
    if (consts.contains(func)) {
      _insert(func);
    } else if (func == '|x|') {
      _insert('abs(');
    } else {
      _insert('$func(');
    }
  }

  void restoreFromHistory(String result) {
    final raw = result.replaceAll(',', '');
    _set(raw, raw.length);
    hasResultNotifier.value = true;
    resultNotifier.value = '';
  }

  void dispose() {
    expressionController.dispose();
    focusNode.dispose();
    resultNotifier.dispose();
    hasResultNotifier.dispose();
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Set text + cursor and refresh the live preview.
  void _set(String text, int cursor) {
    expressionController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursor.clamp(0, text.length)),
    );
    _preview();
  }

  /// Set text + cursor without triggering a preview recalculation.
  void _setRaw(String text, int cursor) {
    expressionController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursor.clamp(0, text.length)),
    );
  }

  void _insert(String text) {
    final newText = _before + text + _after;
    final newCursor = _start + text.length;
    expressionController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursor),
    );
    _preview();
  }

  void _replaceOp(String newOp) {
    final b = _before;
    if (b.isEmpty) return;
    final trimmed = b.substring(0, b.length - 1);
    _set(trimmed + newOp + _after, trimmed.length + newOp.length);
  }

  /// Auto-inserts '×' when the cursor is immediately after a '%' and the next
  /// character is not already an operator.
  void _autoMul() {
    final a = _after;
    if (_before.endsWith('%') &&
        (a.isEmpty || (!_isBinOp(a[0]) && a[0] != ')'))) {
      _insert('×');
    }
  }

  void _preview() {
    final txt = _text.trimRight();
    if (txt.isEmpty || _endsIncomplete(txt)) {
      resultNotifier.value = '';
      return;
    }
    final r = _eval(txt);
    resultNotifier.value = r != null ? NumberFormatter.formatDisplay(r) : '';
  }

  bool _endsIncomplete(String expr) {
    final last = expr[expr.length - 1];
    return _isBinOp(last) || last == '(' || last == '.';
  }

  double? _eval(String expr) {
    try {
      final s = expr.replaceAll(',', '');
      if (s.isEmpty) return null;
      final r = ExprParser(s).parseExpr();
      return (r.isNaN || r.isInfinite) ? null : r;
    } catch (_) {
      return null;
    }
  }

  bool _canInsertOp() {
    final b = _before;
    if (b.isEmpty) return false;
    return RegExp(r'[\d)πeφ%]').hasMatch(b[b.length - 1]);
  }

  String _resolveParen() {
    final open = _text.split('(').length - 1;
    final close = _text.split(')').length - 1;
    if (open == close || _text.isEmpty || _text.endsWith('(')) return '(';
    return ')';
  }

  /// Returns the text of the current number operand immediately before the cursor.
  /// Used to enforce the per-operand digit limit.
  String _operand() {
    const seps = {'+', '−', '×', '÷', '^', '(', ')', ' '};
    final b = _before;
    var last = -1;
    for (final ch in seps) {
      final idx = b.lastIndexOf(ch);
      if (idx > last) last = idx;
    }
    return last < 0 ? b : b.substring(last + 1);
  }

  int _operandDigits() => _operand().replaceAll(RegExp(r'[^\d]'), '').length;

  bool _isDigit(String s) => RegExp(r'^\d+$').hasMatch(s);
  bool _isBinOp(String s) => const {'+', '−', '×', '÷', '^'}.contains(s);
}
