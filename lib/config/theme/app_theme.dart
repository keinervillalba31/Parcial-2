import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Estilo de tienda de tenis: negro tinta, blanco hueso y un naranja de acento.
class AppTheme {
  static const Color ink = Color(0xFF111111);
  static const Color bone = Color(0xFFF4F3EF);
  static const Color accent = Color(0xFFFF5A1F);

  /// Tipografía de títulos (gruesa y compacta, como en las tiendas deportivas).
  static TextStyle display(double size, {Color? color}) => GoogleFonts.archivo(
    fontSize: size,
    fontWeight: FontWeight.w900,
    height: 0.95,
    letterSpacing: -0.5,
    color: color,
  );

  static ThemeData themeData({required bool isDark}) {
    final base = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
    final scheme = isDark
        ? base.copyWith(
            primary: bone,
            onPrimary: ink,
            primaryContainer: const Color(0xFF2A2A2A),
            onPrimaryContainer: bone,
            secondary: accent,
            onSecondary: Colors.white,
            tertiary: accent,
            surface: const Color(0xFF0E0E0E),
            onSurface: bone,
            onSurfaceVariant: const Color(0xFFA3A19B),
            surfaceContainerLowest: const Color(0xFF0A0A0A),
            surfaceContainerLow: const Color(0xFF151515),
            surfaceContainer: const Color(0xFF181818),
            surfaceContainerHigh: const Color(0xFF1F1F1F),
            surfaceContainerHighest: const Color(0xFF262626),
            outline: const Color(0xFF55534E),
            outlineVariant: const Color(0xFF2C2B29),
          )
        : base.copyWith(
            primary: ink,
            onPrimary: Colors.white,
            primaryContainer: const Color(0xFFE6E4DE),
            onPrimaryContainer: ink,
            secondary: accent,
            onSecondary: Colors.white,
            tertiary: accent,
            surface: bone,
            onSurface: ink,
            onSurfaceVariant: const Color(0xFF6B6962),
            surfaceContainerLowest: Colors.white,
            surfaceContainerLow: Colors.white,
            surfaceContainer: const Color(0xFFF0EFEA),
            surfaceContainerHigh: const Color(0xFFEAE8E2),
            surfaceContainerHighest: const Color(0xFFE6E4DE),
            outline: const Color(0xFFBDBAB2),
            outlineVariant: const Color(0xFFDDDAD3),
          );

    final textTheme = GoogleFonts.interTextTheme(
      ThemeData(brightness: scheme.brightness).textTheme,
    ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
    TextStyle? heading(TextStyle? style) => style == null
        ? null
        : GoogleFonts.archivo(
            textStyle: style,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          );

    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme.copyWith(
        displaySmall: heading(textTheme.displaySmall),
        headlineLarge: heading(textTheme.headlineLarge),
        headlineMedium: heading(textTheme.headlineMedium),
        headlineSmall: heading(textTheme.headlineSmall),
        titleLarge: heading(textTheme.titleLarge),
        titleMedium: heading(textTheme.titleMedium),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        shape: Border(bottom: BorderSide(color: scheme.outlineVariant)),
        titleTextStyle: GoogleFonts.archivo(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: scheme.onSurface,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: rounded.copyWith(side: BorderSide(color: scheme.outlineVariant)),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.onSurface, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.archivo(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.onSurface,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: StadiumBorder(side: BorderSide(color: scheme.outlineVariant)),
        backgroundColor: scheme.surfaceContainerLowest,
        selectedColor: scheme.primary,
        showCheckmark: false,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? scheme.onPrimary
                : scheme.onSurface,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primary,
        selectedIconTheme: IconThemeData(color: scheme.onPrimary),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        selectedLabelTextStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelTextStyle: TextStyle(color: scheme.onSurfaceVariant),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primary,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.onPrimary
                : scheme.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: scheme.onSurface,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w500,
          ),
        ),
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: accent,
        textColor: Colors.white,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: accent),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? bone : ink,
        contentTextStyle: TextStyle(color: isDark ? ink : Colors.white),
        actionTextColor: accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        shape: rounded,
      ),
    );
  }
}
