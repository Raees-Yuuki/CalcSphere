import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/modal_num_pad.dart';
import '../../../core/utils/number_formatter.dart';

class UnitPriceScreen extends StatefulWidget {
  const UnitPriceScreen({super.key});
  @override
  State<UnitPriceScreen> createState() => _UnitPriceScreenState();
}

class _UnitPriceScreenState extends State<UnitPriceScreen> {
  final _items = [_Item('A'), _Item('B'), _Item('C'), _Item('D')];

  int? get _bestIdx {
    double best = double.infinity;
    int? idx;
    for (var i = 0; i < _items.length; i++) {
      final up = _items[i].unitPrice;
      if (up > 0 && up < best) {
        best = up;
        idx = i;
      }
    }
    return idx;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Unit Price'),
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
          ..._items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            final isBest = _bestIdx == i;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isBest
                      ? const Color(0xFF34C759)
                      : (isDark
                            ? const Color(0xFF3A3A3C)
                            : const Color(0xFFC6C6C8)),
                  width: isBest ? 2 : 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isBest
                              ? const Color(0xFF34C759)
                              : const Color(0xFF8E8E93),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          item.label,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (isBest) ...[
                        const SizedBox(width: 8),
                        Text(
                          'Best Value',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF34C759),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _fieldTile('Price', item.price, '₹', () async {
                          final v = await ModalNumPad.show(
                            context,
                            fieldName: 'Price ${item.label}',
                            unit: '₹',
                          );
                          if (v != null)
                            setState(
                              () => item.price = double.tryParse(v) ?? 0,
                            );
                        }),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _fieldTile('Qty', item.qty, '', () async {
                          final v = await ModalNumPad.show(
                            context,
                            fieldName: 'Quantity ${item.label}',
                          );
                          if (v != null)
                            setState(() => item.qty = double.tryParse(v) ?? 0);
                        }),
                      ),
                    ],
                  ),
                  if (item.unitPrice > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      '₹${NumberFormatter.formatFixed(item.unitPrice, 2)}/unit',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isBest ? const Color(0xFF34C759) : null,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _fieldTile(String l, double v, String u, VoidCallback t) {
    return GestureDetector(
      onTap: t,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            v > 0
                ? '${u.isNotEmpty ? '$u ' : ''}${NumberFormatter.formatFixed(v, 2)}'
                : 'Tap',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _Item {
  final String label;
  double price, qty;
  _Item(this.label) : price = 0, qty = 0;
  double get unitPrice => qty > 0 ? price / qty : 0;
}
