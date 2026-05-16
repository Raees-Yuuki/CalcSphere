import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/modal_num_pad.dart';
import '../../../core/utils/number_formatter.dart';

class TipScreen extends StatefulWidget {
  const TipScreen({super.key});
  @override
  State<TipScreen> createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
  double _bill = 0, _tipPct = 10;
  int _people = 1;
  final _chips = [10.0, 15.0, 18.0, 20.0, 25.0];

  double get _tip => _bill * _tipPct / 100;
  double get _total => _bill + _tip;
  double get _perPerson => _people > 0 ? _total / _people : _total;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Tip'), leading: Builder(builder: (c) => IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () => Scaffold.of(c).openDrawer()))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _card(isDark, [
          _field('Bill Amount', _bill, '₹', () => _input('Bill Amount', '₹').then((v) { if (v != null) setState(() => _bill = v); })),
          _field('People', _people.toDouble(), '', () => _input('People', '').then((v) { if (v != null) setState(() => _people = v.toInt().clamp(1, 100)); })),
        ]),
        const SizedBox(height: 16),
        Text('Tip %', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93))),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: _chips.map((c) => ChoiceChip(label: Text('${c.toInt()}%'), selected: _tipPct == c, onSelected: (_) => setState(() => _tipPct = c))).toList()),
        const SizedBox(height: 16),
        _card(isDark, [
          _res('Tip Amount', '₹${NumberFormatter.formatFixed(_tip, 2)}', const Color(0xFF34C759)),
          _res('Total', '₹${NumberFormatter.formatFixed(_total, 2)}', accent),
          if (_people > 1) _res('Per Person', '₹${NumberFormatter.formatFixed(_perPerson, 2)}', null),
        ]),
      ]),
    );
  }

  Future<double?> _input(String n, String u) async { final v = await ModalNumPad.show(context, fieldName: n, unit: u); return v != null ? double.tryParse(v) : null; }
  Widget _card(bool d, List<Widget> ch) => Container(decoration: BoxDecoration(color: d ? const Color(0xFF2C2C2E) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: d ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8), width: 0.5)), child: Column(children: ch));
  Widget _field(String l, double v, String u, VoidCallback t) => ListTile(title: Text(l, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93))), trailing: Text(v > 0 ? '${NumberFormatter.formatFixed(v, 0)}${u.isNotEmpty ? ' $u' : ''}' : 'Tap to enter', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500)), onTap: t);
  Widget _res(String l, String v, Color? c) => ListTile(title: Text(l, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93))), trailing: Text(v, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: c)));
}
