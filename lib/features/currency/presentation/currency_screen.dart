// lib/features/currency/presentation/currency_screen.dart
// (Purani location — yahi file replace karo apni existing currency_screen.dart se)
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:calc_sphere/features/currency/controller/currency_controller.dart';
import 'package:calc_sphere/features/currency/widgets/currency_card.dart';
import 'package:calc_sphere/features/currency/widgets/currency_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/num_pad.dart';
import '../../../core/widgets/swap_button.dart';
import '../../../core/utils/number_formatter.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final controller = CurrencyController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _pick(bool isFrom) async {
    final title = isFrom ? 'From Currency' : 'To Currency';
    final currentSelected = isFrom ? controller.from : controller.to;

    final String? selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CurrencyPickerSheet(
        title: title,
        controller: controller,
        initialSelected: currentSelected,
      ),
    );

    if (selected != null && selected != currentSelected) {
      await controller.setCurrency(isFrom: isFrom, value: selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Scaffold(
          drawer: const AppDrawer(),

          appBar: AppBar(
            title: const Text('Currency'),
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CurrencyCard(
                        cur: controller.from,
                        flag: CurrencyController.flagFor(controller.from),
                        amt: controller.amount.isEmpty ? '' : controller.amount,
                        isDark: isDark,
                        active: true,
                        onPick: () => _pick(true),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '1 ${controller.from} = ${NumberFormatter.formatFixed(controller.rate, 4)} ${controller.to}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF8E8E93),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (controller.loading)
                                  const ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                    child: LinearProgressIndicator(
                                      minHeight: 3,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          SwapButton(onSwap: controller.swap),
                        ],
                      ),

                      const SizedBox(height: 8),

                      CurrencyCard(
                        cur: controller.to,
                        flag: CurrencyController.flagFor(controller.to),
                        amt: controller.converted,
                        isDark: isDark,
                        active: false,
                        onPick: () => _pick(false),
                      ),

                      const SizedBox(height: 12),

                      if (controller.rate > 0)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Live exchange rate • Auto updates every 15 sec',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: NumPad(
                    onKeyPressed: controller.onKey,
                    onBackspace: controller.onBack,
                    onClear: controller.clear,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
