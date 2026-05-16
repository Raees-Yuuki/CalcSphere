import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/modal_num_pad.dart';
import '../../../core/utils/number_formatter.dart';

class FuelCostScreen extends StatefulWidget {
  const FuelCostScreen({super.key});
  @override
  State<FuelCostScreen> createState() => _FuelCostScreenState();
}

class _FuelCostScreenState extends State<FuelCostScreen> {
  double _distance = 40, _efficiency = 15, _price = 100;
  bool _km = true;

  double get _fuelNeeded => _efficiency > 0 ? _distance / _efficiency : 0;
  double get _cost => _fuelNeeded * _price;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Fuel Cost'),
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
          // Toggle km/miles
          Row(
            children: [
              ChoiceChip(
                label: const Text('km'),
                selected: _km,
                onSelected: (_) => setState(() => _km = true),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('miles'),
                selected: !_km,
                onSelected: (_) => setState(() => _km = false),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _card(isDark, [
            _field(
              'Distance',
              _distance,
              _km ? 'km' : 'mi',
              () => _input('Distance', _km ? 'km' : 'mi').then((v) {
                if (v != null) setState(() => _distance = v);
              }),
            ),
            _field(
              'Fuel Efficiency',
              _efficiency,
              _km ? 'km/L' : 'mpg',
              () => _input('Fuel Efficiency', _km ? 'km/L' : 'mpg').then((v) {
                if (v != null) setState(() => _efficiency = v);
              }),
            ),
            _field(
              'Fuel Price',
              _price,
              '₹/L',
              () => _input('Fuel Price', '₹/L').then((v) {
                if (v != null) setState(() => _price = v);
              }),
            ),
          ]),
          const SizedBox(height: 16),
          _card(isDark, [
            _res(
              'Fuel Needed',
              '${NumberFormatter.formatFixed(_fuelNeeded, 2)} L',
              null,
            ),
            _res(
              'Estimated Cost',
              '₹${NumberFormatter.formatFixed(_cost, 2)}',
              accent,
            ),
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
      '${NumberFormatter.formatFixed(v, 1)} $u',
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
