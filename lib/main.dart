import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('preferences');
  await Hive.openBox('history');

  // Lock portrait orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: CalcSphereApp()));
}

class CalcSphereApp extends ConsumerWidget {
  const CalcSphereApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final accentColor = ref.watch(accentColorProvider);

    return MaterialApp.router(
      title: 'CalcSphere',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light(accent: accentColor),
      darkTheme: AppTheme.dark(accent: accentColor),
      routerConfig: appRouter,
    );
  }
}
