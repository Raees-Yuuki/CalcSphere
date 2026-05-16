import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/modal_num_pad.dart';
import '../../../core/utils/number_formatter.dart';

class GstScreen extends StatefulWidget {
  const GstScreen({super.key});
  @override
  State<GstScreen> createState() => _GstScreenState();
}

class _GstScreenState extends State<GstScreen> {
  double _price = 0, _rate = 18;
  bool _addGst = true;
  final _rates = [5.0, 12.0, 18.0, 28.0];

  double get _taxAmt =>
      _addGst ? _price * _rate / 100 : _price - (_price * 100 / (100 + _rate));
  double get _total => _addGst ? _price + _price * _rate / 100 : _price;
  double get _original => _addGst ? _price : _price * 100 / (100 + _rate);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('GST'),
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
          // Toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _addGst = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _addGst ? accent : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Add GST',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _addGst
                              ? Colors.white
                              : const Color(0xFF8E8E93),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _addGst = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !_addGst ? accent : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Remove GST',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: !_addGst
                              ? Colors.white
                              : const Color(0xFF8E8E93),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Rate chips
          Wrap(
            spacing: 8,
            children: _rates
                .map(
                  (r) => ChoiceChip(
                    label: Text('${r.toInt()}%'),
                    selected: _rate == r,
                    onSelected: (_) => setState(() => _rate = r),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          // Input
          _card(isDark, [
            ListTile(
              title: Text(
                _addGst ? 'Original Price' : 'Price with GST',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF8E8E93),
                ),
              ),
              trailing: Text(
                _price > 0
                    ? '₹${NumberFormatter.formatFixed(_price, 2)}'
                    : 'Tap to enter',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                final v = await ModalNumPad.show(
                  context,
                  fieldName: 'Price',
                  unit: '₹',
                );
                if (v != null) setState(() => _price = double.tryParse(v) ?? 0);
              },
            ),
          ]),
          const SizedBox(height: 16),
          // Results
          _card(isDark, [
            _res('Tax Rate', '${_rate.toStringAsFixed(0)}%', null),
            _res(
              'Tax Amount',
              '₹${NumberFormatter.formatFixed(_taxAmt, 2)}',
              const Color(0xFFFF9500),
            ),
            _res(
              _addGst ? 'Total Price' : 'Original Price',
              '₹${NumberFormatter.formatFixed(_addGst ? _total : _original, 2)}',
              accent,
            ),
          ]),
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
