import 'package:flutter/material.dart';
import 'package:pub_dev_packages_app/core/assets_gen/colors.gen.dart';

extension AppColorContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

class LightColorScheme {
  static const Color primary = ColorName.primary;
  static const Color secondary = ColorName.secondary;
  static const Color tertiary = ColorName.tertiary;
  static const Color surface = ColorName.surface;
  static const Color onSurface = ColorName.onSurface;
  static const Color background = ColorName.background;
  static const Color onBackground = ColorName.onBackground;
  static const Color error = ColorName.error;
  static const Color errorContainer = ColorName.errorContainer;
  static const Color outline = ColorName.outline;
  static const Color outlineVariant = ColorName.outlineVariant;
  static const Color scrim = ColorName.scrim;
  static const Color onPrimary = ColorName.onPrimary;
  static const Color onSecondary = ColorName.onSecondary;
  static const Color onTertiary = ColorName.onTertiary;
  static const Color onSurfaceVariant = ColorName.onSurfaceVariant;
  static const Color onError = ColorName.onError;
  static const Color shadow = ColorName.shadow; 
  static const Color surfaceContainer = ColorName.surfaceContainer;
  static const Color surfaceContainerHigh = ColorName.surfaceContainerHigh;
}

class DarkColorScheme {
  static const Color primary = ColorName.primary;
  static const Color secondary = ColorName.secondary;
  static const Color tertiary = ColorName.tertiary;
  static const Color surface = ColorName.surface;
  static const Color onSurface = ColorName.onSurface;
  static const Color background = ColorName.background;
  static const Color onBackground = ColorName.onBackground;
  static const Color error = ColorName.error;
  static const Color errorContainer = ColorName.errorContainer;
  static const Color outline = ColorName.outline;
  static const Color outlineVariant = ColorName.outlineVariant;
  static const Color scrim = ColorName.scrim;
  static const Color onPrimary = ColorName.onPrimary;
  static const Color onSecondary = ColorName.onSecondary;
  static const Color onTertiary = ColorName.onTertiary;
  static const Color onSurfaceVariant = ColorName.onSurfaceVariant;
  static const Color onError = ColorName.onError;
  static const Color shadow = ColorName.shadow;
  static const Color surfaceContainer = ColorName.surfaceContainer;
  static const Color surfaceContainerHigh = ColorName.surfaceContainerHigh;
}
