import 'package:go_router/go_router.dart';
import '../../features/calculator/presentation/calculator_screen.dart';
import '../../features/currency/presentation/currency_screen.dart';
import '../../features/unit_converter/presentation/unit_converter_screen.dart';
import '../../features/discount/presentation/discount_screen.dart';
import '../../features/gst/presentation/gst_screen.dart';
import '../../features/fuel_cost/presentation/fuel_cost_screen.dart';
import '../../features/fuel_efficiency/presentation/fuel_efficiency_screen.dart';
import '../../features/body_metrics/presentation/body_metrics_screen.dart';
import '../../features/loan/presentation/loan_screen.dart';
import '../../features/grade_average/presentation/grade_average_screen.dart';
import '../../features/tip/presentation/tip_screen.dart';
import '../../features/world_time/presentation/world_time_screen.dart';
import '../../features/hex_converter/presentation/hex_converter_screen.dart';
import '../../features/unit_price/presentation/unit_price_screen.dart';
import '../../features/percentage/presentation/percentage_screen.dart';
import '../../features/date_calculator/presentation/date_calculator_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

/// GoRouter configuration with deep links for all 16 calculators + settings.
final appRouter = GoRouter(
  initialLocation: '/calculator',
  routes: [
    GoRoute(path: '/', name: 'home', redirect: (_, __) => '/calculator'),
    GoRoute(
      path: '/calculator',
      name: 'calculator',
      builder: (context, state) => const CalculatorScreen(),
    ),
    GoRoute(
      path: '/currency',
      name: 'currency',
      builder: (context, state) => const CurrencyScreen(),
    ),
    GoRoute(
      path: '/unit-converter',
      name: 'unit_converter',
      builder: (context, state) => const UnitConverterScreen(),
    ),
    GoRoute(
      path: '/discount',
      name: 'discount',
      builder: (context, state) => const DiscountScreen(),
    ),
    GoRoute(
      path: '/gst',
      name: 'gst',
      builder: (context, state) => const GstScreen(),
    ),
    GoRoute(
      path: '/fuel-cost',
      name: 'fuel_cost',
      builder: (context, state) => const FuelCostScreen(),
    ),
    GoRoute(
      path: '/fuel-efficiency',
      name: 'fuel_efficiency',
      builder: (context, state) => const FuelEfficiencyScreen(),
    ),
    GoRoute(
      path: '/body-metrics',
      name: 'body_metrics',
      builder: (context, state) => const BodyMetricsScreen(),
    ),
    GoRoute(
      path: '/loan',
      name: 'loan',
      builder: (context, state) => const LoanScreen(),
    ),
    GoRoute(
      path: '/gpa',
      name: 'gpa',
      builder: (context, state) => const GradeAverageScreen(),
    ),
    GoRoute(
      path: '/tip',
      name: 'tip',
      builder: (context, state) => const TipScreen(),
    ),
    GoRoute(
      path: '/world-time',
      name: 'world_time',
      builder: (context, state) => const WorldTimeScreen(),
    ),
    GoRoute(
      path: '/hex',
      name: 'hex',
      builder: (context, state) => const HexConverterScreen(),
    ),
    GoRoute(
      path: '/unit-price',
      name: 'unit_price',
      builder: (context, state) => const UnitPriceScreen(),
    ),
    GoRoute(
      path: '/percentage',
      name: 'percentage',
      builder: (context, state) => const PercentageScreen(),
    ),
    GoRoute(
      path: '/date',
      name: 'date_calculator',
      builder: (context, state) => const DateCalculatorScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => const CalculatorScreen(),
);
