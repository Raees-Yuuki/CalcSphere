import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/modal_num_pad.dart';
import '../../../core/utils/number_formatter.dart';

class FuelEfficiencyScreen extends StatefulWidget {
  const FuelEfficiencyScreen({super.key});
  @override
  State<FuelEfficiencyScreen> createState() => _FuelEfficiencyScreenState();
}

class _FuelEfficiencyScreenState extends State<FuelEfficiencyScreen> {
  double _distance = 0, _fuelAdded = 0;

  double get _kmPerL => _fuelAdded > 0 ? _distance / _fuelAdded : 0;
  double get _lPer100 => _distance > 0 ? (_fuelAdded / _distance) * 100 : 0;
  double get _mpg => _kmPerL * 2.35215;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Fuel Efficiency'),
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
          _card(isDark, [
            _field(
              'Distance Travelled',
              _distance,
              'km',
              () => _input('Distance', 'km').then((v) {
                if (v != null) setState(() => _distance = v);
              }),
            ),
            _field(
              'Fuel Added',
              _fuelAdded,
              'L',
              () => _input('Fuel Added', 'L').then((v) {
                if (v != null) setState(() => _fuelAdded = v);
              }),
            ),
          ]),
          const SizedBox(height: 16),
          _card(isDark, [
            _res('km/L', NumberFormatter.formatFixed(_kmPerL, 2), accent),
            _res('L/100km', NumberFormatter.formatFixed(_lPer100, 2), null),
            _res('MPG', NumberFormatter.formatFixed(_mpg, 2), null),
          ]),
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
  Widget _res(String l, String v, Color? c) => ListTile(
    title: Text(
      l,
      style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93)),
    ),
    trailing: Text(
      v,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: c,
      ),
    ),
  );
}
