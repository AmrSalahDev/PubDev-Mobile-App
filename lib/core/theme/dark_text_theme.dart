import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextTheme darkTextTheme(ColorScheme colorScheme) {
  final base = ThemeData.dark().textTheme;

  return base.copyWith(
    // Display
    displayLarge: base.displayLarge?.copyWith(
      fontSize: 48.sp,
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
      letterSpacing: -1.0,
    ),
    displayMedium: base.displayMedium?.copyWith(
      fontSize: 40.sp,
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
      letterSpacing: -0.8,
    ),
    displaySmall: base.displaySmall?.copyWith(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
      letterSpacing: -0.5,
    ),

    // Headline
    headlineMedium: base.headlineMedium?.copyWith(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),

    // Title
    titleLarge: base.titleLarge?.copyWith(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
    ),
    titleMedium: base.titleMedium?.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),
    titleSmall: base.titleSmall?.copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),

    // Body
    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: 16.sp,
      color: colorScheme.onSurface,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontSize: 14.sp,
      color: colorScheme.onSurface,
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontSize: 12.sp,
      color: colorScheme.onSurfaceVariant,
    ),

    // Label
    labelLarge: base.labelLarge?.copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
    ),
    labelMedium: base.labelMedium?.copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurfaceVariant,
    ),
    labelSmall: base.labelSmall?.copyWith(
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurfaceVariant,
    ),
  );
}
