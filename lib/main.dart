import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('preferences');
  await Hive.openBox('history');
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: CalcSphereApp()));
}

class CalcSphereApp extends ConsumerStatefulWidget {
  const CalcSphereApp({super.key});

  @override
  ConsumerState<CalcSphereApp> createState() => _CalcSphereAppState();
}

class _CalcSphereAppState extends ConsumerState<CalcSphereApp> {
  // Prevents re-applying dynamic colour on every rebuild
  bool _dynamicColorSeeded = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final accentColor = ref.watch(accentColorProvider);
    final oledMode = ref.watch(oledModeProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Seed rawDynamicColorProvider once when OS provides wallpaper colours
        if (lightDynamic != null && !_dynamicColorSeeded) {
          _dynamicColorSeeded = true;
          final wallpaperColor = lightDynamic.primary;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Always cache raw dynamic colour so theme_screen can read it
            ref.read(rawDynamicColorProvider.notifier).state = wallpaperColor;

            // If Material You was saved ON (cold boot), apply immediately
            if (ref.read(materialYouProvider)) {
              ref.read(accentColorProvider.notifier).setColor(wallpaperColor);
            }
          });
        }

        return MaterialApp.router(
          title: 'CalcSphere',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: AppTheme.light(accent: accentColor),
          darkTheme: AppTheme.dark(accent: accentColor, isOled: oledMode),
          routerConfig: appRouter,
        );
      },
    );
  }
}
