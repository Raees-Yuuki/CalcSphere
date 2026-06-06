import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/swap_button.dart';
import '../../../core/widgets/num_pad.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});
  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  String _category = 'Length';
  int _fromIdx = 0, _toIdx = 1;
  String _value = '';

  static const _categories = {
    'Length': [
      'Meter',
      'Kilometer',
      'Centimeter',
      'Millimeter',
      'Mile',
      'Yard',
      'Foot',
      'Inch',
    ],
    'Weight': ['Kilogram', 'Gram', 'Milligram', 'Pound', 'Ounce', 'Ton'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Volume': ['Liter', 'Milliliter', 'Gallon', 'Cup', 'Fluid Oz'],
    'Speed': ['m/s', 'km/h', 'mph', 'knot'],
    'Area': ['m²', 'km²', 'hectare', 'acre', 'ft²'],
    'Data': ['Byte', 'KB', 'MB', 'GB', 'TB'],
  };

  static const _toMeters = {
    'Meter': 1.0,
    'Kilometer': 1000.0,
    'Centimeter': 0.01,
    'Millimeter': 0.001,
    'Mile': 1609.34,
    'Yard': 0.9144,
    'Foot': 0.3048,
    'Inch': 0.0254,
  };
  static const _toKg = {
    'Kilogram': 1.0,
    'Gram': 0.001,
    'Milligram': 0.000001,
    'Pound': 0.453592,
    'Ounce': 0.0283495,
    'Ton': 1000.0,
  };
  static const _toL = {
    'Liter': 1.0,
    'Milliliter': 0.001,
    'Gallon': 3.78541,
    'Cup': 0.236588,
    'Fluid Oz': 0.0295735,
  };
  static const _toMs = {
    'm/s': 1.0,
    'km/h': 0.277778,
    'mph': 0.44704,
    'knot': 0.514444,
  };
  static const _toM2 = {
    'm²': 1.0,
    'km²': 1e6,
    'hectare': 1e4,
    'acre': 4046.86,
    'ft²': 0.092903,
  };
  static const _toByte = {
    'Byte': 1.0,
    'KB': 1024.0,
    'MB': 1048576.0,
    'GB': 1073741824.0,
    'TB': 1099511627776.0,
  };

  List<String> get _units => _categories[_category]!;
  String get _fromUnit => _units[_fromIdx % _units.length];
  String get _toUnit => _units[_toIdx % _units.length];

  String get _result {
    if (_value.isEmpty) return '0';
    final v = double.tryParse(_value) ?? 0;
    final converted = _convert(v, _fromUnit, _toUnit);
    if (converted == null) return '—';
    final s = converted.toStringAsFixed(6);
    return double.parse(s).toString();
  }

  double? _convert(double val, String from, String to) {
    if (_category == 'Temperature') return _convertTemp(val, from, to);
    final map = _getMap();
    if (map == null || !map.containsKey(from) || !map.containsKey(to))
      return null;
    return val * map[from]! / map[to]!;
  }

  Map<String, double>? _getMap() {
    switch (_category) {
      case 'Length':
        return _toMeters;
      case 'Weight':
        return _toKg;
      case 'Volume':
        return _toL;
      case 'Speed':
        return _toMs;
      case 'Area':
        return _toM2;
      case 'Data':
        return _toByte;
      default:
        return null;
    }
  }

  double? _convertTemp(double v, String from, String to) {
    double celsius;
    switch (from) {
      case 'Fahrenheit':
        celsius = (v - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = v - 273.15;
        break;
      default:
        celsius = v;
    }
    switch (to) {
      case 'Fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  void _swap() => setState(() {
    final t = _fromIdx;
    _fromIdx = _toIdx;
    _toIdx = t;
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Unit Converter'),
        leading: Builder(
          builder: (c) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(c).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _categories.keys
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(c),
                        selected: _category == c,
                        onSelected: (_) {
                          setState(() {
                            _category = c;
                            _fromIdx = 0;
                            _toIdx = 1;
                            _value = '';
                          });
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _UnitField(
                    label: _fromUnit,
                    value: _value.isEmpty ? '0' : _value,
                    isDark: isDark,
                    active: true,
                    onPick: () => _pickUnit(true),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Spacer(),
                      SwapButton(onSwap: _swap),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _UnitField(
                    label: _toUnit,
                    value: _result,
                    isDark: isDark,
                    active: false,
                    onPick: () => _pickUnit(false),
                  ),
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
                onKeyPressed: (k) => setState(() {
                  if (k == '.' && _value.contains('.')) return;
                  _value = (_value == '0' && k != '.') ? k : _value + k;
                }),
                onBackspace: () => setState(() {
                  if (_value.isNotEmpty)
                    _value = _value.substring(0, _value.length - 1);
                }),
                onClear: () => setState(() => _value = ''),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickUnit(bool isFrom) async {
    final s = await showModalBottomSheet<int>(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: _units.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, i) => ListTile(
          title: Text(_units[i]),
          onTap: () => Navigator.pop(context, i),
        ),
      ),
    );
    if (s != null)
      setState(() {
        if (isFrom)
          _fromIdx = s;
        else
          _toIdx = s;
      });
  }
}

class _UnitField extends StatelessWidget {
  final String label, value;
  final bool isDark, active;
  final VoidCallback onPick;
  const _UnitField({
    required this.label,
    required this.value,
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
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
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
              value,
              style: GoogleFonts.inter(
                fontSize: 24,
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
