import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextTheme lightTextTheme(BuildContext context) {
  final base = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;

  return base.copyWith(
    // Display
    displayLarge: base.displayLarge?.copyWith(
      fontSize: 48.sp,
      color: colorScheme.onSurface,
    ),
    displayMedium: base.displayMedium?.copyWith(
      fontSize: 40.sp,
      color: colorScheme.onSurface,
    ),
    displaySmall: base.displaySmall?.copyWith(
      fontSize: 32.sp,
      color: colorScheme.onSurface,
    ),

    // Headline
    headlineMedium: base.headlineMedium?.copyWith(
      fontSize: 24.sp,
      color: colorScheme.onSurface,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontSize: 20.sp,
      color: colorScheme.onSurface,
    ),

    // Title
    titleLarge: base.titleLarge?.copyWith(
      fontSize: 18.sp,
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
      color: colorScheme.onSurface,
    ),
  );
}
