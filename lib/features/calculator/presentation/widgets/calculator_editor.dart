import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/calculator_controller.dart';

double _fontFor(int len) {
  if (len < 15) return 48.0;
  if (len < 25) return 42.0;
  if (len < 40) return 36.0;
  if (len < 60) return 30.0;
  return 26.0;
}

class CalculatorEditor extends StatelessWidget {
  const CalculatorEditor({super.key, required this.controller});
  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _ExpressionField(
                controller: controller,
                textColor: textColor,
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
              valueListenable: controller.resultNotifier,
              builder: (_, result, __) => Text(
                result,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF8E8E93),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpressionField extends StatefulWidget {
  const _ExpressionField({required this.controller, required this.textColor});
  final CalculatorController controller;
  final Color textColor;

  @override
  State<_ExpressionField> createState() => _ExpressionFieldState();
}

class _ExpressionFieldState extends State<_ExpressionField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late Animation<double> _sizeAnim;
  double _target = 48;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _sizeAnim = Tween<double>(
      begin: 48,
      end: 48,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    widget.controller.expressionController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final next = _fontFor(widget.controller.expressionController.text.length);
    if (next != _target) {
      final from = _sizeAnim.value;
      _sizeAnim = Tween<double>(
        begin: from,
        end: next,
      ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
      _target = next;
      _anim.forward(from: 0);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    widget.controller.expressionController.removeListener(_onTextChanged);
    _anim.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final fontSize = _sizeAnim.value;

        return ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: ClampingScrollPhysics(),
            child: TextField(
              controller: widget.controller.expressionController,
              focusNode: widget.controller.focusNode,
              readOnly: true,
              showCursor: true,
              enableInteractiveSelection: true,
              maxLines: null,
              minLines: null,
              textAlign: TextAlign.right,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              decoration: const InputDecoration(
                filled: false,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              cursorWidth: 2,
              cursorColor: widget.textColor,
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: widget.textColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
