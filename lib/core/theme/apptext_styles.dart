import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.greyDark,
  );

  static const TextStyle bold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.greyLight,
  );

  static const TextStyle error = TextStyle(
    fontSize: 14,
    color: AppColors.error,
  );
}
