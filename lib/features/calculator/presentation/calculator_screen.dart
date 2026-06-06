// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';
import '../controller/calculator_controller.dart';
import '../../../core/widgets/num_pad.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../shared/services/history_service.dart';
import 'widgets/calculator_editor.dart';
import 'widgets/calculator_toolbar.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late final CalculatorController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = CalculatorController();
    _ctrl.onError = (msg) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: GoogleFonts.inter(fontSize: 14)),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    };
    // Request focus so the native cursor is visible immediately on open.
    // readOnly:true means no system keyboard will appear.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _ctrl.focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

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
            icon: const Icon(Icons.menu),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Expression + result display ──────────────────────────────────
          CalculatorEditor(controller: _ctrl),

          // ── Toolbar (…  ^  ⌫) ──────────────────────────────────────────
          CalculatorToolbar(
            controller: _ctrl,
            onShowScientific: () => _showScientific(context),
          ),

          // ── NumPad ──────────────────────────────────────────────────────
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
                onKeyPressed: _ctrl.onKeyPressed,
                onClear: _ctrl.onClear,
                onEquals: _ctrl.onEquals,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Share ────────────────────────────────────────────────────────────────

  void _share() {
    final expr = _ctrl.expressionController.text;
    final result = _ctrl.resultNotifier.value;
    if (expr.isEmpty) return;
    final body = result.isEmpty
        ? 'Expression:\n$expr'
        : 'Expression:\n$expr\n\nResult:\n$result';
    Share.share(body);
  }

  // ── History bottom sheet ────────────────────────────────────────────────

  void _showHistory(BuildContext context) {
    final entries = HistoryService().getAll('standard');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.85,
        minChildSize: 0.3,
        expand: false,
        builder: (ctx, sc) {
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
            controller: sc,
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
                  _ctrl.restoreFromHistory(e.result);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }

  // ── Scientific functions bottom sheet ───────────────────────────────────

  void _showScientific(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
    final cardColor = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final textColor = Theme.of(context).colorScheme.primary;

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
                                _ctrl.onScientificFunctionSelected(fn);
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
                                  fn,
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
}
