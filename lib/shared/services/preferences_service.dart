import 'package:hive_flutter/hive_flutter.dart';

/// User preferences persistence using Hive.
class PreferencesService {
  static const _boxName = 'preferences';

  Box get _box => Hive.box(_boxName);

  // ── Theme ──
  String get themeMode =>
      _box.get('themeMode', defaultValue: 'system') as String;
  set themeMode(String v) => _box.put('themeMode', v);

  // ── Accent Color ──
  int get accentColorValue =>
      _box.get('accentColor', defaultValue: 0xFF007AFF) as int;
  set accentColorValue(int v) => _box.put('accentColor', v);

  // ── Number Format ──
  bool get useIndianFormat =>
      _box.get('indianFormat', defaultValue: true) as bool;
  set useIndianFormat(bool v) => _box.put('indianFormat', v);

  // ── Decimal Places ──
  int get decimalPlaces => _box.get('decimalPlaces', defaultValue: 2) as int;
  set decimalPlaces(int v) => _box.put('decimalPlaces', v);

  // ── Haptic ──
  bool get hapticEnabled =>
      _box.get('hapticEnabled', defaultValue: true) as bool;
  set hapticEnabled(bool v) => _box.put('hapticEnabled', v);

  // ── Home Currency ──
  String get homeCurrency =>
      _box.get('homeCurrency', defaultValue: 'INR') as String;
  set homeCurrency(String v) => _box.put('homeCurrency', v);

  // ── Pro User ──
  bool get isProUser => _box.get('isProUser', defaultValue: false) as bool;
  set isProUser(bool v) => _box.put('isProUser', v);

  // ── Favourites ──
  List<String> get favourites {
    final raw = _box.get(
      'favourites',
      defaultValue: ['calculator', 'currency', 'gst'],
    );
    return List<String>.from(raw as List);
  }

  set favourites(List<String> v) => _box.put('favourites', v);
}
