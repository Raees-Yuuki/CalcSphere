import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/modal_num_pad.dart';
import '../../../core/utils/number_formatter.dart';

class PercentageScreen extends StatefulWidget {
  const PercentageScreen({super.key});
  @override
  State<PercentageScreen> createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  int _mode = 0; // 0: X is what % of Y, 1: What is X% of Y, 2: % change
  double _x = 0, _y = 0;

  String get _result {
    if (_x == 0 && _y == 0) return '—';
    switch (_mode) {
      case 0:
        return _y != 0
            ? '${NumberFormatter.formatFixed(_x / _y * 100, 2)}%'
            : '—';
      case 1:
        return NumberFormatter.formatFixed(_x / 100 * _y, 2);
      case 2:
        return _x != 0
            ? '${NumberFormatter.formatFixed((_y - _x) / _x * 100, 2)}%'
            : '—';
      default:
        return '—';
    }
  }

  String get _description {
    switch (_mode) {
      case 0:
        return '${NumberFormatter.formatFixed(_x, 0)} is what % of ${NumberFormatter.formatFixed(_y, 0)}?';
      case 1:
        return 'What is ${NumberFormatter.formatFixed(_x, 0)}% of ${NumberFormatter.formatFixed(_y, 0)}?';
      case 2:
        return '% change from ${NumberFormatter.formatFixed(_x, 0)} to ${NumberFormatter.formatFixed(_y, 0)}';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Percentage'),
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
          // Mode toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [0, 1, 2].map((m) {
                final sel = _mode == m;
                final labels = ['X is %', 'X% of Y', '% Change'];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _mode = m;
                      _x = 0;
                      _y = 0;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: sel ? accent : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        labels[m],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: sel ? Colors.white : const Color(0xFF8E8E93),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _card(isDark, [
            _field(
              _mode == 1 ? 'X (%)' : (_mode == 2 ? 'From' : 'X'),
              _x,
              () async {
                final v = await ModalNumPad.show(
                  context,
                  fieldName: _mode == 1 ? 'X (%)' : 'X',
                );
                if (v != null) setState(() => _x = double.tryParse(v) ?? 0);
              },
            ),
            _field(_mode == 2 ? 'To' : 'Y', _y, () async {
              final v = await ModalNumPad.show(context, fieldName: 'Y');
              if (v != null) setState(() => _y = double.tryParse(v) ?? 0);
            }),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
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
              children: [
                Text(
                  _description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _result,
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
  Widget _field(String l, double v, VoidCallback t) => ListTile(
    title: Text(
      l,
      style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93)),
    ),
    trailing: Text(
      v > 0 ? NumberFormatter.formatFixed(v, 2) : 'Tap to enter',
      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    onTap: t,
  );
}
