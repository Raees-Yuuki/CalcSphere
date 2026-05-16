import 'package:flutter/material.dart';

/// Metadata about each calculator module for the drawer and routing.
class CalculatorInfo {
  final String id;
  final String name;
  final String route;
  final IconData icon;
  final Color color;

  const CalculatorInfo({
    required this.id,
    required this.name,
    required this.route,
    required this.icon,
    required this.color,
  });

  static const List<CalculatorInfo> all = [
    CalculatorInfo(
      id: 'calculator',
      name: 'Calculator',
      route: '/calculator',
      icon: Icons.calculate_rounded,
      color: Color(0xFF007AFF),
    ),
    CalculatorInfo(
      id: 'currency',
      name: 'Currency',
      route: '/currency',
      icon: Icons.currency_exchange_rounded,
      color: Color(0xFF34C759),
    ),
    CalculatorInfo(
      id: 'unit_converter',
      name: 'Unit Converter',
      route: '/unit-converter',
      icon: Icons.swap_horiz_rounded,
      color: Color(0xFF007AFF),
    ),
    CalculatorInfo(
      id: 'discount',
      name: 'Discount',
      route: '/discount',
      icon: Icons.discount_rounded,
      color: Color(0xFF34C759),
    ),
    CalculatorInfo(
      id: 'gst',
      name: 'GST',
      route: '/gst',
      icon: Icons.receipt_long_rounded,
      color: Color(0xFFFF9500),
    ),
    CalculatorInfo(
      id: 'fuel_cost',
      name: 'Fuel Cost',
      route: '/fuel-cost',
      icon: Icons.local_gas_station_rounded,
      color: Color(0xFFFF3B30),
    ),
    CalculatorInfo(
      id: 'fuel_efficiency',
      name: 'Fuel Efficiency',
      route: '/fuel-efficiency',
      icon: Icons.speed_rounded,
      color: Color(0xFFFF3B30),
    ),
    CalculatorInfo(
      id: 'body_metrics',
      name: 'Body Metrics',
      route: '/body-metrics',
      icon: Icons.monitor_weight_rounded,
      color: Color(0xFFAF52DE),
    ),
    CalculatorInfo(
      id: 'loan',
      name: 'Loan',
      route: '/loan',
      icon: Icons.account_balance_rounded,
      color: Color(0xFF5AC8FA),
    ),
    CalculatorInfo(
      id: 'grade_average',
      name: 'GPA',
      route: '/gpa',
      icon: Icons.school_rounded,
      color: Color(0xFFFFD60A),
    ),
    CalculatorInfo(
      id: 'tip',
      name: 'Tip',
      route: '/tip',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFFF2D55),
    ),
    CalculatorInfo(
      id: 'world_time',
      name: 'World Time',
      route: '/world-time',
      icon: Icons.public_rounded,
      color: Color(0xFF007AFF),
    ),
    CalculatorInfo(
      id: 'hex_converter',
      name: 'Hex Converter',
      route: '/hex',
      icon: Icons.tag_rounded,
      color: Color(0xFF8E8E93),
    ),
    CalculatorInfo(
      id: 'unit_price',
      name: 'Unit Price',
      route: '/unit-price',
      icon: Icons.shopping_cart_rounded,
      color: Color(0xFFFF9500),
    ),
    CalculatorInfo(
      id: 'percentage',
      name: 'Percentage',
      route: '/percentage',
      icon: Icons.percent_rounded,
      color: Color(0xFFAF52DE),
    ),
    CalculatorInfo(
      id: 'date_calculator',
      name: 'Date Calculator',
      route: '/date',
      icon: Icons.calendar_today_rounded,
      color: Color(0xFFFF3B30),
    ),
  ];

  static CalculatorInfo? byId(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
