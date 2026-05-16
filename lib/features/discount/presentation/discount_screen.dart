import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/modal_num_pad.dart';
import '../../../core/utils/number_formatter.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});
  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  double _price = 0, _discount = 0, _tax = 0;

  double get _saved => _price * _discount / 100;
  double get _afterDiscount => _price - _saved;
  double get _taxAmt => _afterDiscount * _tax / 100;
  double get _final => _afterDiscount + _taxAmt;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Discount'), leading: Builder(builder:(c)=>IconButton(icon:const Icon(Icons.menu_rounded),onPressed:()=>Scaffold.of(c).openDrawer()))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _buildCard(isDark, [
          _row('Original Price', _price, '₹', ()=>_input('Original Price','₹').then((v){if(v!=null)setState(()=>_price=v);})),
          _row('Discount', _discount, '%', ()=>_input('Discount','%').then((v){if(v!=null)setState(()=>_discount=v);})),
          _row('Tax', _tax, '%', ()=>_input('Tax','%').then((v){if(v!=null)setState(()=>_tax=v);})),
        ]),
        const SizedBox(height: 16),
        _buildCard(isDark, [
          _resultRow('You Save', NumberFormatter.formatFixed(_saved, 2), const Color(0xFF34C759)),
          _resultRow('Tax Amount', NumberFormatter.formatFixed(_taxAmt, 2), null),
          _resultRow('Final Price', NumberFormatter.formatFixed(_final, 2), Theme.of(context).colorScheme.primary),
        ]),
      ]),
    );
  }

  Future<double?> _input(String name, String unit) async {
    final v = await ModalNumPad.show(context, fieldName: name, unit: unit);
    return v != null ? double.tryParse(v) : null;
  }

  Widget _buildCard(bool isDark, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(color: isDark?const Color(0xFF2C2C2E):Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark?const Color(0xFF3A3A3C):const Color(0xFFC6C6C8), width: 0.5)),
      child: Column(children: children),
    );
  }

  Widget _row(String label, double val, String unit, VoidCallback onTap) {
    return ListTile(
      title: Text(label, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93))),
      trailing: Text(val > 0 ? '${NumberFormatter.formatFixed(val, 2)} $unit' : 'Tap to enter', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  Widget _resultRow(String label, String val, Color? color) {
    return ListTile(
      title: Text(label, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93))),
      trailing: Text(val, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
