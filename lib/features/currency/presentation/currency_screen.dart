// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/swap_button.dart';
import '../../../core/widgets/num_pad.dart';
import '../../../core/utils/number_formatter.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});
  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  String _from = 'USD', _to = 'INR', _amount = '';
  double _rate = 95.50;
  static const _curs = [
    'USD',
    'INR',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'SGD',
    'AED',
    'BRL',
    'KRW',
    'MXN',
  ];
  static const _flags = {
    'USD': '🇺🇸',
    'INR': '🇮🇳',
    'EUR': '🇪🇺',
    'GBP': '🇬🇧',
    'JPY': '🇯🇵',
    'AUD': '🇦🇺',
    'CAD': '🇨🇦',
    'CHF': '🇨🇭',
    'CNY': '🇨🇳',
    'SGD': '🇸🇬',
    'AED': '🇦🇪',
    'BRL': '🇧🇷',
    'KRW': '🇰🇷',
    'MXN': '🇲🇽',
  };

  String get _converted {
    if (_amount.isEmpty) return '';
    final v = double.tryParse(_amount) ?? 0;
    return NumberFormatter.formatFixed(v * _rate, 2);
  }

  void _swap() => setState(() {
    final t = _from;
    _from = _to;
    _to = t;
    _rate = _rate != 0 ? 1 / _rate : 0;
  });
  void _onKey(String k) => setState(() {
    if (k == '.' && _amount.contains('.')) return;
    _amount = (_amount == '0' && k != '.') ? k : _amount + k;
  });
  void _onBack() => setState(() {
    if (_amount.isNotEmpty) _amount = _amount.substring(0, _amount.length - 1);
  });

  Future<void> _pick(bool isFrom) async {
    final s = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1C1C1E)
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        expand: false,
        builder: (ctx, ctrl) => ListView.builder(
          controller: ctrl,
          padding: const EdgeInsets.all(16),
          itemCount: _curs.length,
          itemBuilder: (_, i) {
            final c = _curs[i];
            return ListTile(
              leading: Text(
                _flags[c] ?? '🏳️',
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(c),
              onTap: () => Navigator.pop(ctx, c),
            );
          },
        ),
      ),
    );
    if (s != null)
      setState(() {
        if (isFrom)
          _from = s;
        else
          _to = s;
      });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Currency'),
        leading: Builder(
          builder: (c) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(c).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _Card(
                    cur: _from,
                    flag: _flags[_from] ?? '',
                    amt: _amount.isEmpty ? '' : _amount,
                    isDark: isDark,
                    active: true,
                    onPick: () => _pick(true),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '1 $_from = ${NumberFormatter.formatFixed(_rate, 4)} $_to',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF8E8E93),
                          ),
                        ),
                      ),
                      SwapButton(onSwap: _swap),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _Card(
                    cur: _to,
                    flag: _flags[_to] ?? '',
                    amt: _converted,
                    isDark: isDark,
                    active: false,
                    onPick: () => _pick(false),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: SafeArea(
              top: false,
              child: NumPad(
                onKeyPressed: _onKey,
                onBackspace: _onBack,
                onClear: () => setState(() => _amount = ''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String cur, flag, amt;
  final bool isDark, active;
  final VoidCallback onPick;
  const _Card({
    required this.cur,
    required this.flag,
    required this.amt,
    required this.isDark,
    required this.active,
    required this.onPick,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active
              ? Theme.of(context).colorScheme.primary
              : (isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8)),
          width: active ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPick,
            child: Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Text(
                  cur,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Color(0xFF8E8E93),
                ),
              ],
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              amt,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
