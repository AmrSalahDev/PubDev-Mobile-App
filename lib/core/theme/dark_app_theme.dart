import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/theme/app_colors.dart';
import 'package:pub_dev_packages_app/core/theme/dark_text_theme.dart';

ThemeData darkTheme(BuildContext context) {
  final colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: DarkColorScheme.primary,
    secondary: DarkColorScheme.secondary,
    tertiary: DarkColorScheme.tertiary,
    surface: DarkColorScheme.surface,
    surfaceContainer: DarkColorScheme.surfaceContainer,
    background: DarkColorScheme.background,
    error: DarkColorScheme.error,
    errorContainer: DarkColorScheme.errorContainer,
    outline: DarkColorScheme.outline,
    outlineVariant: DarkColorScheme.outlineVariant,
    scrim: DarkColorScheme.scrim,
    onPrimary: DarkColorScheme.onPrimary,
    onSecondary: DarkColorScheme.onSecondary,
    onTertiary: DarkColorScheme.onTertiary,
    onSurface: DarkColorScheme.onSurface,
    onSurfaceVariant: DarkColorScheme.onSurfaceVariant,
    onBackground: DarkColorScheme.onBackground,
    onError: DarkColorScheme.onError,
    shadow: DarkColorScheme.shadow,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    textTheme: darkTextTheme(context),
    scaffoldBackgroundColor: DarkColorScheme.surface,
    tabBarTheme: TabBarThemeData(
      indicatorColor: DarkColorScheme.primary,
      labelColor: DarkColorScheme.primary,
      unselectedLabelColor: DarkColorScheme.onSurfaceVariant,
      dividerColor: DarkColorScheme.outline,
      dividerHeight: 2,
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: DarkColorScheme.primary,
      strokeWidth: 2,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: DarkColorScheme.surface,
      foregroundColor: DarkColorScheme.onSurface,
      surfaceTintColor: DarkColorScheme.surface,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DarkColorScheme.primary,
        foregroundColor: DarkColorScheme.onPrimary,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DarkColorScheme.primary,
        side: const BorderSide(color: DarkColorScheme.primary),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: DarkColorScheme.primary),
    ),
    cardTheme: CardThemeData(
      color: DarkColorScheme.surface,
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
      backgroundColor: DarkColorScheme.surface,
      dragHandleColor: DarkColorScheme.outline,
      dragHandleSize: Size(70.w, 8.w),
      showDragHandle: true,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DarkColorScheme.surface,
      selectedItemColor: DarkColorScheme.primary,
      unselectedItemColor: DarkColorScheme.onSurfaceVariant,
      elevation: 8,
    ),
  );
}
