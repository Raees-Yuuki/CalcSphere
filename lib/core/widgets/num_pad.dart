import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NumPad extends StatelessWidget {
  final void Function(String) onKeyPressed;
  final VoidCallback? onBackspace;
  final VoidCallback? onClear;
  final VoidCallback? onEquals;
  final bool showOperators;
  final bool showDecimal;

  const NumPad({
    super.key,
    required this.onKeyPressed,
    this.onBackspace,
    this.onClear,
    this.onEquals,
    this.showOperators = false,
    this.showDecimal = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    List<List<String>> rows;
    if (showOperators) {
      rows = [
        ['C', '( )', '%', '÷'],
        ['7', '8', '9', '×'],
        ['4', '5', '6', '−'],
        ['1', '2', '3', '+'],
        ['0', '00', '.', '='],
      ];
    } else {
      rows = [
        ['7', '8', '9'],
        ['4', '5', '6'],
        ['1', '2', '3'],
        [if (showDecimal) '.' else '', '0', '⌫'],
      ];
    }

    final rowCount = rows.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availH = constraints.maxHeight;

        // FIX 1: totalGap — pehle 8.0 tha jo sirf ek side ka padding count
        // karta tha. EdgeInsets.all(8) top+bottom dono side lagata hai (16dp),
        // plus har row ka 8dp bottom padding. Corrected formula:
        final totalGap = 16.0 + (rowCount * 8.0);

        // FIX 2: clamp(92.0, 96.0) → clamp(60.0, 100.0)
        // Pehle wala tight clamp SizedBox ke constraints ignore karke hamesha
        // ~96dp force karta tha. Ab wide range dete hain taaki key height
        // screen size ke hisaab se properly adapt ho sake.
        final keyH = availH > 100
            ? ((availH - totalGap) / rowCount).clamp(60.0, 100.0)
            : 60.0;

        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            // FIX 3: mainAxisSize.min → MainAxisSize.max
            // Min se Column sirf apne content jitna space leta tha.
            // Max se ab Column parent SizedBox ki poori height fill karega.
            mainAxisSize: MainAxisSize.max,
            children: rows.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: row.map((key) {
                    if (key.isEmpty) {
                      return Expanded(child: SizedBox(height: keyH));
                    }
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _NumKey(
                          label: key,
                          isDark: isDark,
                          accentColor: theme.colorScheme.primary,
                          keyHeight: keyH,
                          onTap: () => _handleTap(key),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _handleTap(String key) {
    switch (key) {
      case '⌫':
        HapticFeedback.lightImpact();
        onBackspace?.call();
        break;
      case 'C':
        HapticFeedback.mediumImpact();
        onClear?.call();
        break;
      case '=':
        HapticFeedback.heavyImpact();
        onEquals?.call();
        break;
      case '+':
      case '−':
      case '×':
      case '÷':
      case '( )':
      case '%':
        HapticFeedback.mediumImpact();
        onKeyPressed(key);
        break;
      default:
        HapticFeedback.lightImpact();
        onKeyPressed(key);
    }
  }
}

class _NumKey extends StatefulWidget {
  final String label;
  final bool isDark;
  final Color accentColor;
  final VoidCallback onTap;
  final double keyHeight;

  const _NumKey({
    required this.label,
    required this.isDark,
    required this.accentColor,
    required this.onTap,
    this.keyHeight = 72,
  });

  @override
  State<_NumKey> createState() => _NumKeyState();
}

class _NumKeyState extends State<_NumKey> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isOperator =>
      ['+', '−', '×', '÷', '( )', '%'].contains(widget.label);

  bool get _isAction => ['⌫', '=', 'C'].contains(widget.label);

  Color get _bgColor {
    if (_isAction) return widget.accentColor;
    if (_isOperator) {
      return widget.isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA);
    }
    return widget.isDark ? const Color(0xFF2C2C2E) : Colors.white;
  }

  Color get _textColor {
    if (_isAction) return Colors.white;
    if (_isOperator) return widget.accentColor;
    return widget.isDark ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          height: widget.keyHeight,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isDark
                  ? const Color(0xFF3A3A3C)
                  : const Color(0xFFC6C6C8),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 1,
                offset: const Offset(0, 0.5),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: widget.label == '⌫'
              ? Icon(
                  Icons.backspace_rounded,
                  color: _textColor,
                  // FIX 4: Font/icon size clamps widened to match new keyH range.
                  // keyH ab 60-100dp range mein hoga, to clamp bhi match karna chahiye.
                  size: (widget.keyHeight * 0.35).clamp(18.0, 34.0),
                )
              : Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: _isOperator
                        ? (widget.keyHeight * 0.4).clamp(18.0, 38.0)
                        : (widget.keyHeight * 0.44).clamp(22.0, 46.0),
                    fontWeight: _isOperator ? FontWeight.w500 : FontWeight.w400,
                    color: _textColor,
                  ),
                ),
        ),
      ),
    );
  }
}
