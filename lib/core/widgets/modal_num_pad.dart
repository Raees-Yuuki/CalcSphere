import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'num_pad.dart';

/// Modal bottom-sheet numpad for specialty calculators.
/// Dark header with field name, input display, and numpad.
class ModalNumPad extends StatefulWidget {
  final String fieldName;
  final String unit;
  final String initialValue;
  final bool allowDecimal;

  const ModalNumPad({
    super.key,
    required this.fieldName,
    this.unit = '',
    this.initialValue = '',
    this.allowDecimal = true,
  });

  /// Show the modal and return the entered value (or null if dismissed).
  static Future<String?> show(
    BuildContext context, {
    required String fieldName,
    String unit = '',
    String initialValue = '',
    bool allowDecimal = true,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ModalNumPad(
        fieldName: fieldName,
        unit: unit,
        initialValue: initialValue,
        allowDecimal: allowDecimal,
      ),
    );
  }

  @override
  State<ModalNumPad> createState() => _ModalNumPadState();
}

class _ModalNumPadState extends State<ModalNumPad> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _onKey(String key) {
    setState(() {
      if (key == '.' && _value.contains('.')) return;
      if (_value == '0' && key != '.') {
        _value = key;
      } else {
        _value += key;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_value.isNotEmpty) {
        _value = _value.substring(0, _value.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF2C2C2E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Text(
                  widget.fieldName,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white70, size: 22),
                ),
              ],
            ),
          ),
          // Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _value.isEmpty ? '0' : _value,
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: _value.isEmpty
                          ? const Color(0xFF8E8E93)
                          : (isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ),
                if (widget.unit.isNotEmpty)
                  Text(
                    widget.unit,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
              ],
            ),
          ),
          Divider(
            height: 0.5,
            color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8),
          ),
          // Numpad
          NumPad(
            showDecimal: widget.allowDecimal,
            onKeyPressed: _onKey,
            onBackspace: _onBackspace,
            onEquals: () {
              Navigator.pop(context, _value.isEmpty ? null : _value);
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
