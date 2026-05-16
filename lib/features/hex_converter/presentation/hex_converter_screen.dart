import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/num_pad.dart';

class HexConverterScreen extends StatefulWidget {
  const HexConverterScreen({super.key});
  @override
  State<HexConverterScreen> createState() => _HexConverterScreenState();
}

class _HexConverterScreenState extends State<HexConverterScreen> {
  String _dec = '';
  int _activeRow = 0; // 0=DEC,1=HEX,2=OCT,3=BIN

  String get _hex => _dec.isEmpty
      ? ''
      : int.tryParse(_dec)?.toRadixString(16).toUpperCase() ?? '';
  String get _oct =>
      _dec.isEmpty ? '' : int.tryParse(_dec)?.toRadixString(8) ?? '';
  String get _bin =>
      _dec.isEmpty ? '' : int.tryParse(_dec)?.toRadixString(2) ?? '';

  void _onKey(String key) {
    setState(() {
      switch (_activeRow) {
        case 0: // DEC input
          if (RegExp(r'^\d$').hasMatch(key)) _dec += key;
          break;
        case 1: // HEX input
          if (RegExp(r'^[0-9A-Fa-f]$').hasMatch(key)) {
            final hex = _hex + key;
            _dec = (int.tryParse(hex, radix: 16) ?? 0).toString();
          }
          break;
        case 2: // OCT input
          if (RegExp(r'^[0-7]$').hasMatch(key)) {
            final oct = _oct + key;
            _dec = (int.tryParse(oct, radix: 8) ?? 0).toString();
          }
          break;
        case 3: // BIN input
          if (key == '0' || key == '1') {
            final bin = _bin + key;
            _dec = (int.tryParse(bin, radix: 2) ?? 0).toString();
          }
          break;
      }
    });
  }

  void _onBackspace() {
    if (_dec.isEmpty) return;
    setState(() => _dec = _dec.substring(0, _dec.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Hex Converter'),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _row('DEC', _dec.isEmpty ? '0' : _dec, 0, isDark),
                  _row('HEX', _hex.isEmpty ? '0' : _hex, 1, isDark),
                  _row('OCT', _oct.isEmpty ? '0' : _oct, 2, isDark),
                  _row('BIN', _bin.isEmpty ? '0' : _bin, 3, isDark),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hex keys row
                  if (_activeRow == 1)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: Row(
                        children: ['A', 'B', 'C', 'D', 'E', 'F']
                            .map(
                              (k) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _onKey(k),
                                    child: Container(
                                      height: 44,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF3A3A3C)
                                            : const Color(0xFFE5E5EA),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        k,
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  NumPad(
                    onKeyPressed: _onKey,
                    onBackspace: _onBackspace,
                    onClear: () => setState(() => _dec = ''),
                    showDecimal: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, int idx, bool isDark) {
    final active = _activeRow == idx;
    return GestureDetector(
      onTap: () => setState(() => _activeRow = idx),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            SizedBox(
              width: 40,
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8E8E93),
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
