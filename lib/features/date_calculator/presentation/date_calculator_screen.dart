import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/modal_num_pad.dart';

class DateCalculatorScreen extends StatefulWidget {
  const DateCalculatorScreen({super.key});
  @override
  State<DateCalculatorScreen> createState() => _DateCalculatorScreenState();
}

class _DateCalculatorScreenState extends State<DateCalculatorScreen> {
  int _mode = 0; // 0: days between, 1: add/subtract days
  DateTime _date1 = DateTime.now();
  DateTime _date2 = DateTime.now();
  int _days = 0;
  bool _add = true;

  int get _diff => _date2.difference(_date1).inDays.abs();
  DateTime get _resultDate => _add
      ? _date1.add(Duration(days: _days))
      : _date1.subtract(Duration(days: _days));
  String get _weeksStr => '${(_diff / 7).floor()} weeks, ${_diff % 7} days';
  String get _monthsStr {
    int m = (_date2.year - _date1.year) * 12 + _date2.month - _date1.month;
    if (m < 0) m = -m;
    return '$m months';
  }

  Future<void> _pickDate(bool isFirst) async {
    final d = await showDatePicker(
      context: context,
      initialDate: isFirst ? _date1 : _date2,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (d != null)
      setState(() {
        if (isFirst)
          _date1 = d;
        else
          _date2 = d;
      });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    final df = DateFormat('EEE, MMM d, yyyy');
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Date Calculator'),
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
              children: [0, 1].map((m) {
                final sel = _mode == m;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _mode = m),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: sel ? accent : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        m == 0 ? 'Days Between' : 'Add/Subtract',
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
          if (_mode == 0) ...[
            _dateTile('From', _date1, isDark, () => _pickDate(true)),
            const SizedBox(height: 8),
            _dateTile('To', _date2, isDark, () => _pickDate(false)),
            const SizedBox(height: 16),
            _resultCard(isDark, accent, [
              _res('Days', '$_diff days', accent),
              _res('Weeks', _weeksStr, null),
              _res('Months', _monthsStr, null),
            ]),
          ] else ...[
            _dateTile('Start Date', _date1, isDark, () => _pickDate(true)),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Add'),
                  selected: _add,
                  onSelected: (_) => setState(() => _add = true),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Subtract'),
                  selected: !_add,
                  onSelected: (_) => setState(() => _add = false),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _card(isDark, [
              ListTile(
                title: Text(
                  'Days',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
                trailing: Text(
                  _days > 0 ? '$_days' : 'Tap to enter',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  final v = await ModalNumPad.show(
                    context,
                    fieldName: 'Days',
                    allowDecimal: false,
                  );
                  if (v != null) setState(() => _days = int.tryParse(v) ?? 0);
                },
              ),
            ]),
            const SizedBox(height: 16),
            _resultCard(isDark, accent, [
              _res('Result', df.format(_resultDate), accent),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _dateTile(String l, DateTime d, bool dk, VoidCallback t) {
    final df = DateFormat('EEE, MMM d, yyyy');
    return GestureDetector(
      onTap: t,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dk ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: dk ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Text(
              l,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF8E8E93),
              ),
            ),
            const Spacer(),
            Text(
              df.format(d),
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: Color(0xFF8E8E93),
            ),
          ],
        ),
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
  Widget _resultCard(bool d, Color a, List<Widget> ch) => _card(d, ch);
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
