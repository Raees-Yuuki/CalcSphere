import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/modal_num_pad.dart';
import '../../../core/utils/number_formatter.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});
  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  double _principal = 0, _rate = 8.5;
  int _months = 60;
  bool _showTable = false;

  double get _monthlyRate => _rate / 12 / 100;
  double get _monthly {
    if (_principal <= 0 || _monthlyRate <= 0 || _months <= 0) return 0;
    final r = _monthlyRate;
    final n = _months;
    return _principal * r * math.pow(1 + r, n) / (math.pow(1 + r, n) - 1);
  }

  double get _totalPayment => _monthly * _months;
  double get _totalInterest => _totalPayment - _principal;

  List<Map<String, double>> get _amortization {
    final list = <Map<String, double>>[];
    var balance = _principal;
    for (var i = 1; i <= _months && balance > 0; i++) {
      final interest = balance * _monthlyRate;
      final principal = _monthly - interest;
      balance -= principal;
      list.add({
        'month': i.toDouble(),
        'payment': _monthly,
        'principal': principal,
        'interest': interest,
        'balance': balance.abs() < 0.01 ? 0 : balance,
      });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Loan'),
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
              'Principal',
              _principal,
              '₹',
              () => _input('Principal', '₹').then((v) {
                if (v != null) setState(() => _principal = v);
              }),
            ),
            _field(
              'Interest Rate',
              _rate,
              '%',
              () => _input('Interest Rate', '%').then((v) {
                if (v != null) setState(() => _rate = v);
              }),
            ),
            _field(
              'Period',
              _months.toDouble(),
              'mo',
              () => _input('Period (months)', 'mo').then((v) {
                if (v != null) setState(() => _months = v.toInt());
              }),
            ),
          ]),
          const SizedBox(height: 16),
          _card(isDark, [
            _res(
              'Monthly Payment',
              '₹${NumberFormatter.formatFixed(_monthly, 2)}',
              accent,
            ),
            _res(
              'Total Interest',
              '₹${NumberFormatter.formatFixed(_totalInterest, 2)}',
              const Color(0xFFFF9500),
            ),
            _res(
              'Total Payment',
              '₹${NumberFormatter.formatFixed(_totalPayment, 2)}',
              null,
            ),
          ]),
          if (_principal > 0) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => setState(() => _showTable = !_showTable),
              child: Row(
                children: [
                  Text(
                    'Amortization Table',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _showTable ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF8E8E93),
                  ),
                ],
              ),
            ),
            if (_showTable) ...[
              const SizedBox(height: 8),
              Container(
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16,
                    headingRowHeight: 36,
                    dataRowMinHeight: 32,
                    dataRowMaxHeight: 36,
                    columns: const [
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Payment')),
                      DataColumn(label: Text('Principal')),
                      DataColumn(label: Text('Interest')),
                      DataColumn(label: Text('Balance')),
                    ],
                    rows: _amortization
                        .take(12)
                        .map(
                          (r) => DataRow(
                            cells: [
                              DataCell(Text('${r['month']!.toInt()}')),
                              DataCell(
                                Text(
                                  '₹${NumberFormatter.formatFixed(r['payment']!, 0)}',
                                ),
                              ),
                              DataCell(
                                Text(
                                  '₹${NumberFormatter.formatFixed(r['principal']!, 0)}',
                                ),
                              ),
                              DataCell(
                                Text(
                                  '₹${NumberFormatter.formatFixed(r['interest']!, 0)}',
                                ),
                              ),
                              DataCell(
                                Text(
                                  '₹${NumberFormatter.formatFixed(r['balance']!, 0)}',
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
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
