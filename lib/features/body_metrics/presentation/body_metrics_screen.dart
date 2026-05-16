import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/modal_num_pad.dart';
import '../../../core/utils/number_formatter.dart';

class BodyMetricsScreen extends StatefulWidget {
  const BodyMetricsScreen({super.key});
  @override
  State<BodyMetricsScreen> createState() => _BodyMetricsScreenState();
}

class _BodyMetricsScreenState extends State<BodyMetricsScreen> {
  double _height = 0, _weight = 0, _age = 25;
  bool _male = true, _metric = true;

  double get _bmi {
    if (_height <= 0 || _weight <= 0) return 0;
    final h = _metric ? _height / 100 : _height * 0.0254;
    final w = _metric ? _weight : _weight * 0.453592;
    return w / (h * h);
  }

  String get _bmiCategory {
    if (_bmi <= 0) return '—';
    if (_bmi < 18.5) return 'Underweight';
    if (_bmi < 25) return 'Normal';
    if (_bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color get _bmiColor {
    if (_bmi < 18.5) return const Color(0xFF5AC8FA);
    if (_bmi < 25) return const Color(0xFF34C759);
    if (_bmi < 30) return const Color(0xFFFF9500);
    return const Color(0xFFFF3B30);
  }

  double get _bmr {
    if (_height <= 0 || _weight <= 0) return 0;
    final h = _metric ? _height : _height * 2.54;
    final w = _metric ? _weight : _weight * 0.453592;
    if (_male) return 10 * w + 6.25 * h - 5 * _age + 5;
    return 10 * w + 6.25 * h - 5 * _age - 161;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
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
          // Metric/Imperial toggle
          Row(
            children: [
              ChoiceChip(
                label: const Text('Metric'),
                selected: _metric,
                onSelected: (_) => setState(() => _metric = true),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Imperial'),
                selected: !_metric,
                onSelected: (_) => setState(() => _metric = false),
              ),
              const Spacer(),
              ChoiceChip(
                label: const Text('Male'),
                selected: _male,
                onSelected: (_) => setState(() => _male = true),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Female'),
                selected: !_male,
                onSelected: (_) => setState(() => _male = false),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _card(isDark, [
            _field(
              'Height',
              _height,
              _metric ? 'cm' : 'in',
              () => _input('Height', _metric ? 'cm' : 'in').then((v) {
                if (v != null) setState(() => _height = v);
              }),
            ),
            _field(
              'Weight',
              _weight,
              _metric ? 'kg' : 'lb',
              () => _input('Weight', _metric ? 'kg' : 'lb').then((v) {
                if (v != null) setState(() => _weight = v);
              }),
            ),
            _field(
              'Age',
              _age,
              'yrs',
              () => _input('Age', 'yrs').then((v) {
                if (v != null) setState(() => _age = v);
              }),
            ),
          ]),
          const SizedBox(height: 16),
          // BMI Bar
          if (_bmi > 0) ...[
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
                        NumberFormatter.formatFixed(_bmi, 1),
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: _bmiColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _bmiCategory,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _bmiColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // BMI Bar
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
                                ((_bmi.clamp(10, 40) - 10) / 30) *
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
                    '${NumberFormatter.formatFixed(_bmr, 0)} kcal/day',
                    accent,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<double?> _input(String n, String u) async {
    final v = await ModalNumPad.show(context, fieldName: n, unit: u);
    return v != null ? double.tryParse(v) : null;
  }

  Widget _card(bool d, List<Widget> ch) => Container(
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
  Widget _field(String l, double v, String u, VoidCallback t) => ListTile(
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
  Widget _res2(String l, String v, Color c) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        l,
        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93)),
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
