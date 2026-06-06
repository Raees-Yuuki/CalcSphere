import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/utils/expr_parser.dart';

class GstScreen extends StatefulWidget {
  const GstScreen({super.key});

  @override
  State<GstScreen> createState() => _GstScreenState();
}

class _GstScreenState extends State<GstScreen> {
  bool _addGst = true;
  int _activeIndex = 0; // 0: Field 1, 1: Field 2, 2: Field 3, 3: Field 4

  // Input states
  String _originalPriceStr = "";
  String _taxRateStr = "5";
  String _taxAmountStr = "";
  String _totalPriceStr = "";

  // Map active index to actual field keys based on active mode
  String _getFieldKey(int index, bool addGst) {
    if (addGst) {
      switch (index) {
        case 0:
          return 'originalPrice';
        case 1:
          return 'taxRate';
        case 2:
          return 'taxAmount';
        case 3:
          return 'totalPrice';
      }
    } else {
      switch (index) {
        case 0:
          return 'totalPrice';
        case 1:
          return 'taxRate';
        case 2:
          return 'taxAmount';
        case 3:
          return 'originalPrice';
      }
    }
    return 'originalPrice';
  }

  // Get field display name for the calculator header
  String _getFieldDisplayName(int index, bool addGst) {
    if (addGst) {
      switch (index) {
        case 0:
          return 'Original price';
        case 1:
          return 'Tax rate';
        case 2:
          return 'Tax amount';
        case 3:
          return 'Total price';
      }
    } else {
      switch (index) {
        case 0:
          return 'Total price';
        case 1:
          return 'Tax rate';
        case 2:
          return 'Tax amount';
        case 3:
          return 'Original price';
      }
    }
    return 'Original price';
  }

  void _setInputStr(String key, String val) {
    switch (key) {
      case 'originalPrice':
        _originalPriceStr = val;
        break;
      case 'taxRate':
        _taxRateStr = val;
        break;
      case 'taxAmount':
        _taxAmountStr = val;
        break;
      case 'totalPrice':
        _totalPriceStr = val;
        break;
    }
  }

  String _getInputStr(String key) {
    switch (key) {
      case 'originalPrice':
        return _originalPriceStr;
      case 'taxRate':
        return _taxRateStr;
      case 'taxAmount':
        return _taxAmountStr;
      case 'totalPrice':
        return _totalPriceStr;
    }
    return "";
  }

  void _recalculate(String activeField) {
    if (activeField == 'originalPrice') {
      double op = double.tryParse(_originalPriceStr) ?? 0.0;
      double tr = double.tryParse(_taxRateStr) ?? 0.0;
      double ta = op * tr / 100.0;
      double tp = op + ta;
      _taxAmountStr = _formatCalc(ta);
      _totalPriceStr = _formatCalc(tp);
    } else if (activeField == 'taxRate') {
      double tr = double.tryParse(_taxRateStr) ?? 0.0;
      if (_addGst) {
        double op = double.tryParse(_originalPriceStr) ?? 0.0;
        double ta = op * tr / 100.0;
        double tp = op + ta;
        _taxAmountStr = _formatCalc(ta);
        _totalPriceStr = _formatCalc(tp);
      } else {
        double tp = double.tryParse(_totalPriceStr) ?? 0.0;
        double op = tp * 100.0 / (100.0 + tr);
        double ta = tp - op;
        _originalPriceStr = _formatCalc(op);
        _taxAmountStr = _formatCalc(ta);
      }
    } else if (activeField == 'taxAmount') {
      double ta = double.tryParse(_taxAmountStr) ?? 0.0;
      double tr = double.tryParse(_taxRateStr) ?? 0.0;
      if (tr > 0) {
        double op = ta * 100.0 / tr;
        double tp = op + ta;
        _originalPriceStr = _formatCalc(op);
        _totalPriceStr = _formatCalc(tp);
      } else {
        double op = double.tryParse(_originalPriceStr) ?? 0.0;
        if (op > 0) {
          tr = ta / op * 100.0;
          _taxRateStr = _formatCalc(tr);
          _totalPriceStr = _formatCalc(op + ta);
        }
      }
    } else if (activeField == 'totalPrice') {
      double tp = double.tryParse(_totalPriceStr) ?? 0.0;
      double tr = double.tryParse(_taxRateStr) ?? 0.0;
      double op = tp * 100.0 / (100.0 + tr);
      double ta = tp - op;
      _originalPriceStr = _formatCalc(op);
      _taxAmountStr = _formatCalc(ta);
    }
  }

  String _formatCalc(double val) {
    if (val == 0.0) return "";
    if (val.isNaN || val.isInfinite) return "";
    if (val == val.toInt()) {
      return val.toInt().toString();
    }
    String s = val.toStringAsFixed(2);
    if (s.endsWith('.00')) return s.substring(0, s.length - 3);
    if (s.endsWith('0')) return s.substring(0, s.length - 1);
    return s;
  }

  // KEYPAD ACTIONS
  void _onKeyPressed(String char) {
    HapticFeedback.lightImpact();
    setState(() {
      final key = _getFieldKey(_activeIndex, _addGst);
      String current = _getInputStr(key);

      // Max input lengths to keep UI looking clean
      if (key == 'taxRate' &&
          current.replaceAll('.', '').length >= 4 &&
          char != '.')
        return;
      if (key != 'taxRate' && current.replaceAll('.', '').length >= 10) return;

      if (char == '.') {
        if (current.contains('.')) return;
        if (current.isEmpty) {
          current = "0.";
        } else {
          current += ".";
        }
      } else if (char == '00') {
        if (current == '0' || current.isEmpty) {
          current = "0";
        } else {
          current += "00";
        }
      } else {
        if (current == '0') {
          current = char;
        } else {
          current += char;
        }
      }
      _setInputStr(key, current);
      _recalculate(key);
    });
  }

  void _onBackspace() {
    HapticFeedback.lightImpact();
    setState(() {
      final key = _getFieldKey(_activeIndex, _addGst);
      String current = _getInputStr(key);
      if (current.isNotEmpty) {
        current = current.substring(0, current.length - 1);
        _setInputStr(key, current);
        _recalculate(key);
      }
    });
  }

  void _onClear() {
    HapticFeedback.mediumImpact();
    setState(() {
      final key = _getFieldKey(_activeIndex, _addGst);
      _setInputStr(key, "");
      _recalculate(key);
    });
  }

  void _onNextField() {
    HapticFeedback.lightImpact();
    setState(() {
      _activeIndex = (_activeIndex + 1) % 4;
    });
  }

  // Toggles the modal dialog default calculator on top of the main GST screen
  void _onMathToggle() {
    HapticFeedback.mediumImpact();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    final activeKey = _getFieldKey(_activeIndex, _addGst);
    final activeVal = _getInputStr(activeKey);
    final displayName = _getFieldDisplayName(_activeIndex, _addGst);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: _CalculatorDialog(
            fieldName: displayName,
            initialValue: activeVal,
            isDark: isDark,
            accent: accent,
            onApply: (String formattedVal) {
              setState(() {
                _setInputStr(activeKey, formattedVal);
                _recalculate(activeKey);
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1C1C1E)
          : const Color(0xFFF2F2F7),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        title: Text(
          'GST',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        leading: Builder(
          builder: (c) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(c).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildToggle(isDark, accent),
                        const SizedBox(height: 24),
                        _buildCards(isDark, accent),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildKeypadContainer(isDark, accent),
        ],
      ),
    );
  }

  Widget _buildToggle(bool isDark, Color accent) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _addGst = true;
                  _activeIndex = 0;
                  _recalculate(
                    'originalPrice',
                  ); // Recalculate immediately on toggle
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _addGst ? accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Add GST',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _addGst ? Colors.white : const Color(0xFF8E8E93),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _addGst = false;
                  _activeIndex = 0;
                  _recalculate(
                    'totalPrice',
                  ); // Recalculate immediately on toggle
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !_addGst ? accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Remove GST',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: !_addGst ? Colors.white : const Color(0xFF8E8E93),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCards(bool isDark, Color accent) {
    final List<Widget> cardList = [];

    if (_addGst) {
      cardList.add(
        _buildCard(0, 'Original Price', _originalPriceStr, isDark, accent),
      );
      cardList.add(
        _buildCard(1, 'Tax Rate', _taxRateStr, isDark, accent, suffix: '%'),
      );
      cardList.add(_buildCard(2, 'Tax Amount', _taxAmountStr, isDark, accent));
      cardList.add(
        _buildCard(3, 'Total Price', _totalPriceStr, isDark, accent),
      );
    } else {
      cardList.add(
        _buildCard(0, 'Price with GST', _totalPriceStr, isDark, accent),
      );
      cardList.add(
        _buildCard(1, 'Tax Rate', _taxRateStr, isDark, accent, suffix: '%'),
      );
      cardList.add(_buildCard(2, 'Tax Amount', _taxAmountStr, isDark, accent));
      cardList.add(
        _buildCard(3, 'Original Price', _originalPriceStr, isDark, accent),
      );
    }

    return Column(
      children: cardList
          .map(
            (c) =>
                Padding(padding: const EdgeInsets.only(bottom: 12), child: c),
          )
          .toList(),
    );
  }

  Widget _buildCard(
    int index,
    String label,
    String valStr,
    bool isDark,
    Color accent, {
    String suffix = '',
  }) {
    final bool isActive = _activeIndex == index;

    String displayVal = "";
    Color valColor;

    if (isActive) {
      displayVal = valStr.isEmpty ? "0" : valStr + suffix;
      valColor = isDark ? Colors.white : Colors.black;
    } else {
      if (valStr.isEmpty) {
        if (label == 'Original Price' || label == 'Price with GST') {
          displayVal = "Tap to enter";
          valColor = const Color(0xFF8E8E93);
        } else if (label == 'Tax Rate') {
          displayVal = "0%";
          valColor = const Color(0xFF8E8E93);
        } else {
          displayVal = "0.00";
          valColor = isDark ? Colors.white70 : Colors.black54;
        }
      } else {
        final d = double.tryParse(valStr) ?? 0.0;
        if (label == 'Tax Rate') {
          displayVal = "${_formatCalc(d)}%";
        } else {
          displayVal = NumberFormatter.formatFixed(d, 2);
        }
        valColor = isDark ? Colors.white : Colors.black;
      }
    }

    final Border border = isActive
        ? Border.all(color: accent, width: 2)
        : Border.all(
            color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
            width: 1,
          );

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeIndex = index;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8E8E93),
              ),
            ),
            Text(
              displayVal,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: valColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadContainer(bool isDark, Color accent) {
    final gridColor = isDark
        ? const Color(0xFF1C1C1E)
        : const Color(0xFFF2F2F7);

    return SafeArea(
      top: false,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.44,
        color: gridColor,
        padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 8),
        child: _buildGstKeypad(isDark, accent),
      ),
    );
  }

  Widget _buildGstKeypad(bool isDark, Color accent) {
    final opBgColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE5E5EA);

    return Column(
      children: [
        // Row 1: 7, 8, 9, ⌫
        Row(
          children: [
            _buildKey('7', onTap: () => _onKeyPressed('7'), isDark: isDark),
            _buildKey('8', onTap: () => _onKeyPressed('8'), isDark: isDark),
            _buildKey('9', onTap: () => _onKeyPressed('9'), isDark: isDark),
            _buildKey(
              '⌫',
              onTap: _onBackspace,
              bgColor: accent,
              textColor: Colors.white,
              child: const Icon(
                Icons.backspace_rounded,
                color: Colors.white,
                size: 22,
              ),
              isDark: isDark,
            ),
          ],
        ),
        // Row 2: 4, 5, 6, ▼
        Row(
          children: [
            _buildKey('4', onTap: () => _onKeyPressed('4'), isDark: isDark),
            _buildKey('5', onTap: () => _onKeyPressed('5'), isDark: isDark),
            _buildKey('6', onTap: () => _onKeyPressed('6'), isDark: isDark),
            _buildKey(
              '▼',
              onTap: _onNextField,
              bgColor: opBgColor,
              textColor: accent,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: accent,
                size: 28,
              ),
              isDark: isDark,
            ),
          ],
        ),
        // Row 3: 1, 2, 3, math
        Row(
          children: [
            _buildKey('1', onTap: () => _onKeyPressed('1'), isDark: isDark),
            _buildKey('2', onTap: () => _onKeyPressed('2'), isDark: isDark),
            _buildKey('3', onTap: () => _onKeyPressed('3'), isDark: isDark),
            _buildKey(
              'math',
              onTap: _onMathToggle,
              bgColor: opBgColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '+',
                        style: GoogleFonts.inter(
                          color: accent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '−',
                        style: GoogleFonts.inter(
                          color: accent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '×',
                        style: GoogleFonts.inter(
                          color: accent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '=',
                        style: GoogleFonts.inter(
                          color: accent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isDark: isDark,
            ),
          ],
        ),
        // Row 4: 0, 00, ., C
        Row(
          children: [
            _buildKey('0', onTap: () => _onKeyPressed('0'), isDark: isDark),
            _buildKey('00', onTap: () => _onKeyPressed('00'), isDark: isDark),
            _buildKey('.', onTap: () => _onKeyPressed('.'), isDark: isDark),
            _buildKey(
              'C',
              onTap: _onClear,
              bgColor: opBgColor,
              textColor: accent,
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(
    String label, {
    VoidCallback? onTap,
    Color? bgColor,
    Color? textColor,
    Widget? child,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.095,
        margin: const EdgeInsets.all(4.0),
        child: Material(
          color: bgColor ?? (isDark ? const Color(0xFF2C2C2E) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child:
                  child ??
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color:
                          textColor ?? (isDark ? Colors.white : Colors.black),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Modal Dialog Standard Calculator widget overlaying the GST screen
class _CalculatorDialog extends StatefulWidget {
  final String fieldName;
  final String initialValue;
  final bool isDark;
  final Color accent;
  final ValueChanged<String> onApply;

  const _CalculatorDialog({
    required this.fieldName,
    required this.initialValue,
    required this.isDark,
    required this.accent,
    required this.onApply,
  });

  @override
  State<_CalculatorDialog> createState() => _CalculatorDialogState();
}

class _CalculatorDialogState extends State<_CalculatorDialog> {
  String _expression = "";
  String _result = "";

  @override
  void initState() {
    super.initState();
    // Load current field value as initial calculation base if valid
    if (widget.initialValue.isNotEmpty &&
        widget.initialValue != "Tap to enter") {
      _expression = widget.initialValue.replaceAll(',', '');
      _updateCalcPreview();
    }
  }

  void _onCalcKey(String key) {
    HapticFeedback.lightImpact();
    setState(() {
      _expression += key;
      _updateCalcPreview();
    });
  }

  void _onCalcClear() {
    HapticFeedback.mediumImpact();
    setState(() {
      _expression = "";
      _result = "";
    });
  }

  void _onCalcParen() {
    HapticFeedback.lightImpact();
    setState(() {
      final open = _expression.split('(').length - 1;
      final close = _expression.split(')').length - 1;
      if (open == close || _expression.isEmpty || _expression.endsWith('(')) {
        _expression += '(';
      } else {
        _expression += ')';
      }
      _updateCalcPreview();
    });
  }

  void _onCalcBackspace() {
    HapticFeedback.lightImpact();
    setState(() {
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);
        _updateCalcPreview();
      }
    });
  }

  void _onCalcEquals() {
    HapticFeedback.heavyImpact();
    setState(() {
      if (_expression.isNotEmpty) {
        final r = ExprParser.evaluate(_expression);
        if (r != null) {
          final formatted = _formatCalc(r);
          // Apply calculation directly to active field and close the dialog
          widget.onApply(formatted);
          Navigator.pop(context);
        }
      }
    });
  }

  void _updateCalcPreview() {
    if (_expression.isEmpty) {
      _result = "";
      return;
    }
    final r = ExprParser.evaluate(_expression);
    if (r != null) {
      _result = _formatCalc(r);
    } else {
      _result = "";
    }
  }

  String _formatCalc(double val) {
    if (val == 0.0) return "";
    if (val.isNaN || val.isInfinite) return "";
    if (val == val.toInt()) {
      return val.toInt().toString();
    }
    String s = val.toStringAsFixed(2);
    if (s.endsWith('.00')) return s.substring(0, s.length - 3);
    if (s.endsWith('0')) return s.substring(0, s.length - 1);
    return s;
  }

  void _showScientificFunctions() {
    final cardColor = widget.isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final textColor = widget.accent;

    const fns = [
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
      backgroundColor: widget.isDark
          ? const Color(0xFF1C1C1E)
          : const Color(0xFFF2F2F7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Scientific functions',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: fns.map((row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: row.map((fn) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                _onScientificFunctionSelected(fn);
                              },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  fn,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
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
          ],
        ),
      ),
    );
  }

  void _onScientificFunctionSelected(String func) {
    setState(() {
      final b = _expression;
      if (b.isNotEmpty && RegExp(r'[\d)πeφ%]').hasMatch(b[b.length - 1])) {
        _expression += '×';
      }

      const consts = {'π', 'e', 'φ'};
      if (consts.contains(func)) {
        _expression += func;
      } else if (func == '|x|') {
        _expression += 'abs(';
      } else {
        _expression += '$func(';
      }
      _updateCalcPreview();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDark
        ? const Color(0xFF1C1C1E)
        : const Color(0xFFF2F2F7);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 580),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Dark Header
          Container(
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFF333333),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.fieldName,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // 2. White/Dark Display Area
          Container(
            height: 110,
            width: double.infinity,
            color: widget.isDark ? const Color(0xFF2C2C2E) : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    _expression.isEmpty ? "Standard Calculator" : _expression,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    _result.isNotEmpty ? _result : "0",
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Toolbar
          _buildToolbar(),

          // 4. Keypad
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 6, right: 6, bottom: 8),
              child: _buildKeypad(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded),
            color: widget.accent,
            iconSize: 28,
            onPressed: _showScientificFunctions,
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up_rounded),
            color: widget.accent,
            iconSize: 28,
            onPressed: () => _onCalcKey('^'),
          ),
          IconButton(
            icon: const Icon(Icons.backspace_outlined),
            color: widget.accent,
            iconSize: 22,
            onPressed: _onCalcBackspace,
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    final opBgColor = widget.isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE5E5EA);

    return Column(
      children: [
        // Row 1: C, ( ), %, ÷
        Expanded(
          child: Row(
            children: [
              _buildKey(
                'C',
                onTap: _onCalcClear,
                bgColor: widget.accent,
                textColor: Colors.white,
              ),
              _buildKey(
                '( )',
                onTap: _onCalcParen,
                bgColor: opBgColor,
                textColor: widget.accent,
              ),
              _buildKey(
                '%',
                onTap: () => _onCalcKey('%'),
                bgColor: opBgColor,
                textColor: widget.accent,
              ),
              _buildKey(
                '÷',
                onTap: () => _onCalcKey('÷'),
                bgColor: opBgColor,
                textColor: widget.accent,
              ),
            ],
          ),
        ),
        // Row 2: 7, 8, 9, ×
        Expanded(
          child: Row(
            children: [
              _buildKey('7', onTap: () => _onCalcKey('7')),
              _buildKey('8', onTap: () => _onCalcKey('8')),
              _buildKey('9', onTap: () => _onCalcKey('9')),
              _buildKey(
                '×',
                onTap: () => _onCalcKey('×'),
                bgColor: opBgColor,
                textColor: widget.accent,
              ),
            ],
          ),
        ),
        // Row 3: 4, 5, 6, −
        Expanded(
          child: Row(
            children: [
              _buildKey('4', onTap: () => _onCalcKey('4')),
              _buildKey('5', onTap: () => _onCalcKey('5')),
              _buildKey('6', onTap: () => _onCalcKey('6')),
              _buildKey(
                '−',
                onTap: () => _onCalcKey('−'),
                bgColor: opBgColor,
                textColor: widget.accent,
              ),
            ],
          ),
        ),
        // Row 4: 1, 2, 3, +
        Expanded(
          child: Row(
            children: [
              _buildKey('1', onTap: () => _onCalcKey('1')),
              _buildKey('2', onTap: () => _onCalcKey('2')),
              _buildKey('3', onTap: () => _onCalcKey('3')),
              _buildKey(
                '+',
                onTap: () => _onCalcKey('+'),
                bgColor: opBgColor,
                textColor: widget.accent,
              ),
            ],
          ),
        ),
        // Row 5: 0, 00, ., =
        Expanded(
          child: Row(
            children: [
              _buildKey('0', onTap: () => _onCalcKey('0')),
              _buildKey('00', onTap: () => _onCalcKey('00')),
              _buildKey('.', onTap: () => _onCalcKey('.')),
              _buildKey(
                '=',
                onTap: _onCalcEquals,
                bgColor: widget.accent,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKey(
    String label, {
    VoidCallback? onTap,
    Color? bgColor,
    Color? textColor,
    Widget? child,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: Material(
          color:
              bgColor ??
              (widget.isDark ? const Color(0xFF2C2C2E) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child:
                  child ??
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color:
                          textColor ??
                          (widget.isDark ? Colors.white : Colors.black),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
