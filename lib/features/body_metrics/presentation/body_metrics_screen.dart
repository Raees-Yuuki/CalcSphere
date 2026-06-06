import 'package:calc_sphere/features/body_metrics/controller/body_metrics_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/modal_num_pad.dart';

class BodyMetricsScreen extends StatefulWidget {
  const BodyMetricsScreen({super.key});

  @override
  State<BodyMetricsScreen> createState() => _BodyMetricsScreenState();
}

class _BodyMetricsScreenState extends State<BodyMetricsScreen> {
  final controller = BodyMetricsController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          drawer: const AppDrawer(),
          appBar: AppBar(
            title: const Text('Body Metrics'),
            leading: Builder(
              builder: (c) => IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => Scaffold.of(c).openDrawer(),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Unit + Gender
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Metric'),
                    selected: controller.metric,
                    onSelected: (_) => controller.setUnit(true),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Imperial'),
                    selected: !controller.metric,
                    onSelected: (_) => controller.setUnit(false),
                  ),
                  const Spacer(),
                  ChoiceChip(
                    label: const Text('Male'),
                    selected: controller.male,
                    onSelected: (_) => controller.setGender(true),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Female'),
                    selected: !controller.male,
                    onSelected: (_) => controller.setGender(false),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _card(isDark, [
                _field(
                  'Height',
                  controller.height,
                  controller.metric ? 'cm' : 'in',
                  () async {
                    final value = await _input(
                      'Height',
                      controller.metric ? 'cm' : 'in',
                    );

                    if (value != null) {
                      controller.setHeight(value);
                    }
                  },
                ),

                _field(
                  'Weight',
                  controller.weight,
                  controller.metric ? 'kg' : 'lb',
                  () async {
                    final value = await _input(
                      'Weight',
                      controller.metric ? 'kg' : 'lb',
                    );

                    if (value != null) {
                      controller.setWeight(value);
                    }
                  },
                ),

                _field('Age', controller.age, 'yrs', () async {
                  final value = await _input('Age', 'yrs');

                  if (value != null) {
                    controller.setAge(value);
                  }
                }),
              ]),

              const SizedBox(height: 16),

              if (controller.bmi > 0) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF3A3A3C)
                          : const Color(0xFFC6C6C8),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'BMI',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            NumberFormatter.formatFixed(controller.bmi, 1),
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: controller.bmiColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        controller.bmiCategory,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: controller.bmiColor,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: SizedBox(
                          height: 12,
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 185,
                                    child: Container(
                                      color: const Color(0xFF5AC8FA),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 65,
                                    child: Container(
                                      color: const Color(0xFF34C759),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 50,
                                    child: Container(
                                      color: const Color(0xFFFF9500),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 100,
                                    child: Container(
                                      color: const Color(0xFFFF3B30),
                                    ),
                                  ),
                                ],
                              ),

                              Positioned(
                                left:
                                    ((controller.bmi.clamp(10, 40) - 10) / 30) *
                                    (MediaQuery.of(context).size.width - 64),
                                child: Container(
                                  width: 4,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white : Colors.black,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _res2(
                        'BMR',
                        '${NumberFormatter.formatFixed(controller.bmr, 0)} kcal/day',
                        accent,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<double?> _input(String n, String u) async {
    final value = await ModalNumPad.show(context, fieldName: n, unit: u);

    return value != null ? double.tryParse(value) : null;
  }

  Widget _card(bool d, List<Widget> ch) {
    return Container(
      decoration: BoxDecoration(
        color: d ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: d ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8),
          width: 0.5,
        ),
      ),
      child: Column(children: ch),
    );
  }

  Widget _field(String l, double v, String u, VoidCallback t) {
    return ListTile(
      title: Text(
        l,
        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93)),
      ),
      trailing: Text(
        v > 0 ? '${NumberFormatter.formatFixed(v, 1)} $u' : 'Tap to enter',
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: t,
    );
  }

  Widget _res2(String l, String v, Color c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF8E8E93),
          ),
        ),
        Text(
          v,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: c,
          ),
        ),
      ],
    );
  }
}
