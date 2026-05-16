import 'package:flutter/material.dart';

/// CalcSphere color system — iOS-inspired clean design.
class ColorTokens {
  // ── Light Mode ──
  static const Color lightBackground = Color(0xFFF2F2F7);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFC6C6C8);
  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF8E8E93);
  static const Color lightOperatorBg = Color(0xFFE5E5EA);

  // ── Dark Mode ──
  static const Color darkBackground = Color(0xFF1C1C1E);
  static const Color darkSurface = Color(0xFF2C2C2E);
  static const Color darkBorder = Color(0xFF3A3A3C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF8E8E93);
  static const Color darkOperatorBg = Color(0xFF3A3A3C);

  // ── Accent Colors ──
  static const Color primaryAccent = Color(0xFF007AFF);
  static const Color secondaryAccent = Color(0xFF34C759);
  static const Color errorRed = Color(0xFFFF3B30);

  // ── 6 Accent Presets (Pro) ──
  static const List<Color> accentPresets = [
    Color(0xFF007AFF), // iOS Blue
    Color(0xFF34C759), // iOS Green
    Color(0xFFAF52DE), // iOS Purple
    Color(0xFFFF2D55), // iOS Pink
    Color(0xFFFF9500), // iOS Orange
    Color(0xFF5AC8FA), // iOS Teal
  ];

  static const List<String> accentNames = [
    'Blue',
    'Green',
    'Purple',
    'Pink',
    'Orange',
    'Teal',
  ];

  // ── Drawer Icon Colors ──
  static const Map<String, Color> calculatorColors = {
    'calculator': Color(0xFF007AFF),
    'currency': Color(0xFF34C759),
    'unit_converter': Color(0xFF007AFF),
    'discount': Color(0xFF34C759),
    'gst': Color(0xFFFF9500),
    'fuel_cost': Color(0xFFFF3B30),
    'fuel_efficiency': Color(0xFFFF3B30),
    'body_metrics': Color(0xFFAF52DE),
    'loan': Color(0xFF5AC8FA),
    'grade_average': Color(0xFFFFD60A),
    'tip': Color(0xFFFF2D55),
    'world_time': Color(0xFF007AFF),
    'hex_converter': Color(0xFF8E8E93),
    'unit_price': Color(0xFFFF9500),
    'percentage': Color(0xFFAF52DE),
    'date_calculator': Color(0xFFFF3B30),
  };
}
