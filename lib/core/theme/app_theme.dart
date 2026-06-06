import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';

/// CalcSphere theme — iOS clean aesthetic with Inter typography.
class AppTheme {
  static final TextStyle _lightAppBarTextStyle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: ColorTokens.lightTextPrimary,
  );
  static final TextStyle _darkAppBarTextStyle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: ColorTokens.darkTextPrimary,
  );
  static final TextStyle _inputLabelLight = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ColorTokens.lightTextSecondary,
  );
  static final TextStyle _inputLabelDark = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ColorTokens.darkTextSecondary,
  );
  static final TextTheme _lightTextTheme = _buildTextTheme(
    ColorTokens.lightTextPrimary,
  );
  static final TextTheme _darkTextTheme = _buildTextTheme(
    ColorTokens.darkTextPrimary,
  );

  static ThemeData light({Color accent = ColorTokens.primaryAccent}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorTokens.lightBackground,
      colorScheme: ColorScheme.light(
        primary: accent,
        secondary: ColorTokens.secondaryAccent,
        surface: ColorTokens.lightSurface,
        error: ColorTokens.errorRed,
        onPrimary: Colors.white,
        onSurface: ColorTokens.lightTextPrimary,
        outline: ColorTokens.lightBorder,
      ),
      textTheme: _lightTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorTokens.lightSurface,
        foregroundColor: ColorTokens.lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: _lightAppBarTextStyle,
      ),
      cardTheme: CardThemeData(
        color: ColorTokens.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: ColorTokens.lightBorder, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: ColorTokens.lightBorder,
        thickness: 0.5,
        space: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accent;
          return ColorTokens.lightBorder;
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorTokens.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorTokens.lightBorder,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorTokens.lightBorder,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: _inputLabelLight,
      ),
    );
  }

  static ThemeData dark({
    Color accent = ColorTokens.primaryAccent,
    bool isOled = false,
  }) {
    final bgColor = isOled ? Colors.black : ColorTokens.darkBackground;
    final surfaceColor = isOled
        ? const Color(0xFF0A0A0A)
        : ColorTokens.darkSurface;
    final borderColor = isOled
        ? const Color(0xFF1A1A1A)
        : ColorTokens.darkBorder;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgColor,
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: ColorTokens.secondaryAccent,
        surface: surfaceColor,
        error: ColorTokens.errorRed,
        onPrimary: Colors.white,
        onSurface: ColorTokens.darkTextPrimary,
        outline: borderColor,
      ),
      textTheme: _darkTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: ColorTokens.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: _darkAppBarTextStyle,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 0.5,
        space: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accent;
          return borderColor;
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorTokens.darkBorder,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorTokens.darkBorder,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: _inputLabelDark,
      ),
    );
  }

  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
    );
  }
}
