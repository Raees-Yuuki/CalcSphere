import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/theme/color_tokens.dart';

/// Manages theme mode (light/dark/system).
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  void _load() {
    final box = Hive.box('preferences');
    final saved = box.get('themeMode', defaultValue: 'system') as String;
    state = _fromString(saved);
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    final box = Hive.box('preferences');
    box.put('themeMode', _toString(mode));
  }

  void toggle() {
    if (state == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }

  static ThemeMode _fromString(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _toString(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

/// Manages accent color selection.
final accentColorProvider = StateNotifierProvider<AccentColorNotifier, Color>((
  ref,
) {
  return AccentColorNotifier();
});

class AccentColorNotifier extends StateNotifier<Color> {
  AccentColorNotifier() : super(ColorTokens.primaryAccent) {
    _load();
  }

  void _load() {
    final box = Hive.box('preferences');
    final saved = box.get('accentColor', defaultValue: 0xFF007AFF) as int;
    state = Color(saved);
  }

  void setColor(Color color) {
    state = color;
    final box = Hive.box('preferences');
    box.put('accentColor', color.toARGB32());
  }
}

// ─── Generic bool toggle notifier ────────────────────────────────
class _BoolNotifier extends StateNotifier<bool> {
  final String _key;
  _BoolNotifier(this._key, bool defaultValue) : super(defaultValue) {
    final box = Hive.box('preferences');
    state = box.get(_key, defaultValue: defaultValue) as bool;
  }

  void toggle() {
    state = !state;
    Hive.box('preferences').put(_key, state);
  }

  void set(bool value) {
    state = value;
    Hive.box('preferences').put(_key, value);
  }
}

/// Default Theme toggle.
final defaultThemeProvider = StateNotifierProvider<_BoolNotifier, bool>((ref) {
  return _BoolNotifier('defaultTheme', true);
});

/// Material You toggle.
final materialYouProvider = StateNotifierProvider<_BoolNotifier, bool>((ref) {
  return _BoolNotifier('materialYou', false);
});

/// Liquid Mode toggle.
final liquidModeProvider = StateNotifierProvider<_BoolNotifier, bool>((ref) {
  return _BoolNotifier('liquidMode', false);
});

/// Bloom toggle.
final bloomProvider = StateNotifierProvider<_BoolNotifier, bool>((ref) {
  return _BoolNotifier('bloom', true);
});

/// OLED Mode toggle.
final oledModeProvider = StateNotifierProvider<_BoolNotifier, bool>((ref) {
  return _BoolNotifier('oledMode', false);
});

/// Custom Theme enabled toggle.
final customThemeEnabledProvider = StateNotifierProvider<_BoolNotifier, bool>((
  ref,
) {
  return _BoolNotifier('customThemeEnabled', false);
});

/// Custom theme color selection.
final customThemeColorProvider =
    StateNotifierProvider<CustomThemeColorNotifier, Color>((ref) {
      return CustomThemeColorNotifier();
    });

class CustomThemeColorNotifier extends StateNotifier<Color> {
  CustomThemeColorNotifier() : super(const Color(0xFF4CAF50)) {
    _load();
  }

  void _load() {
    final box = Hive.box('preferences');
    final saved = box.get('customThemeColor', defaultValue: 0xFF4CAF50) as int;
    state = Color(saved);
  }

  void setColor(Color color) {
    state = color;
    Hive.box('preferences').put('customThemeColor', color.toARGB32());
  }
}

/// Palette selection.
final paletteProvider = StateNotifierProvider<PaletteNotifier, String>((ref) {
  return PaletteNotifier();
});

class PaletteNotifier extends StateNotifier<String> {
  PaletteNotifier() : super('TonalSpot') {
    _load();
  }

  void _load() {
    final box = Hive.box('preferences');
    state = box.get('palette', defaultValue: 'TonalSpot') as String;
  }

  void setPalette(String palette) {
    state = palette;
    Hive.box('preferences').put('palette', palette);
  }
}

/// Manages favourite calculators list.
final favouritesProvider =
    StateNotifierProvider<FavouritesNotifier, List<String>>((ref) {
      return FavouritesNotifier();
    });

class FavouritesNotifier extends StateNotifier<List<String>> {
  FavouritesNotifier() : super([]) {
    _load();
  }

  void _load() {
    final box = Hive.box('preferences');
    final saved = box.get(
      'favourites',
      defaultValue: ['calculator', 'currency', 'gst'],
    );
    state = List<String>.from(saved as List);
  }

  void toggle(String id) {
    if (state.contains(id)) {
      state = [...state]..remove(id);
    } else {
      state = [...state, id];
    }
    final box = Hive.box('preferences');
    box.put('favourites', state);
  }

  bool isFavourite(String id) => state.contains(id);
}

final rawDynamicColorProvider = StateProvider<Color?>((ref) => null);
