import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/theme/app_colors.dart';
import 'package:pub_dev_packages_app/core/theme/light_text_theme.dart';

ThemeData lightTheme(BuildContext context) {
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: LightColorScheme.primary,
    secondary: LightColorScheme.secondary,
    tertiary: LightColorScheme.tertiary,
    surface: LightColorScheme.surface,
    surfaceContainer: LightColorScheme.surfaceContainer,
    background: LightColorScheme.background,
    error: LightColorScheme.error,
    errorContainer: LightColorScheme.errorContainer,
    outline: LightColorScheme.outline,
    outlineVariant: LightColorScheme.outlineVariant,
    scrim: LightColorScheme.scrim,
    onPrimary: LightColorScheme.onPrimary,
    onSecondary: LightColorScheme.onSecondary,
    onTertiary: LightColorScheme.onTertiary,
    onSurface: LightColorScheme.onSurface,
    onSurfaceVariant: LightColorScheme.onSurfaceVariant,
    onBackground: LightColorScheme.onBackground,
    onError: LightColorScheme.onError,
    shadow: LightColorScheme.shadow,
    surfaceContainerHigh: LightColorScheme.surfaceContainerHigh,

  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    textTheme: lightTextTheme(context),
    scaffoldBackgroundColor: LightColorScheme.surface,
    tabBarTheme: TabBarThemeData(
      indicatorColor: LightColorScheme.primary,
      labelColor: LightColorScheme.primary,
      unselectedLabelColor: LightColorScheme.onSurfaceVariant,
      dividerColor: LightColorScheme.outline,
      dividerHeight: 2,
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: LightColorScheme.primary,
      strokeWidth: 2,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: LightColorScheme.surface,
      foregroundColor: LightColorScheme.onSurface,
      surfaceTintColor: LightColorScheme.surface,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LightColorScheme.primary,
        foregroundColor: LightColorScheme.onPrimary,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: LightColorScheme.primary,
        side: const BorderSide(color: LightColorScheme.primary),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: LightColorScheme.primary),
    ),
    cardTheme: CardThemeData(
      color: LightColorScheme.surfaceContainer,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LightColorScheme.surfaceContainerHigh,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.r),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.r),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.r),
        borderSide: BorderSide.none,
      ),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: LightColorScheme.surface,
      dragHandleColor: LightColorScheme.outline,
      dragHandleSize: Size(70.w, 8.w),
      showDragHandle: true,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: LightColorScheme.surface,
      selectedItemColor: LightColorScheme.primary,
      unselectedItemColor: LightColorScheme.onSurfaceVariant,
      elevation: 8,
    ),
  );
}
