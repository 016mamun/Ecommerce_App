import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

extension AppThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Backgrounds
  Color get bgColor => isDark ? AppColors.darkBg : AppColors.lightBg;
  Color get surfaceColor => isDark ? AppColors.darkSurface : AppColors.lightSurface;
  Color get cardColor => isDark ? AppColors.darkCard : AppColors.lightCard;
  Color get borderColor => isDark ? AppColors.darkBorder : AppColors.lightBorder;

  // Text
  Color get textPrimaryColor => isDark ? const Color(0xFFE8E8F0) : const Color(0xFF1A1A2E);
  Color get textSecondaryColor => isDark ? const Color(0xFF9090B0) : const Color(0xFF5A6074);
  Color get textMutedColor => isDark ? const Color(0xFF5A5A7A) : const Color(0xFFAAAAAA);

  // Icon bg used in tiles/cards
  Color get iconBgColor => isDark ? AppColors.darkBg : const Color(0xFFF0F0FA);

  // Input fill
  Color get inputFillColor => isDark ? AppColors.darkSurface : const Color(0xFFF5F5FC);

  // Shadow / overlay
  Color get shadowColor => isDark ? Colors.black26 : Colors.black12;
}
