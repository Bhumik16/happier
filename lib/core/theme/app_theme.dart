import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTheme {
  // Singleton pattern
  static final AppTheme _instance = AppTheme._internal();
  factory AppTheme() => _instance;
  AppTheme._internal();

  // Observable theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.dark.obs;
  ThemeMode get themeMode => _themeMode.value;

  // Check if dark mode
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  // ✅ ADDED: Alias for convenience
  bool get isDark => isDarkMode;

  // Set theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
  }

  // ==================== BACKGROUND COLORS ====================

  // ✅ WARM CREAM BACKGROUND (instead of gray)
  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF1a1a1a) : const Color(0xFFFAF6F0);

  // ✅ WARM LIGHT CARD COLOR
  Color get cardColor =>
      isDarkMode ? const Color(0xFF2a2a2a) : const Color(0xFFFFFBF5);

  Color get appBarColor =>
      isDarkMode ? const Color(0xFF1a1a1a) : const Color(0xFFFAF6F0);

  Color get scaffoldBackgroundColor =>
      isDarkMode ? const Color(0xFF1a1a1a) : const Color(0xFFFAF6F0);

  // ==================== TEXT COLORS ====================

  // ✅ SOFTER DARK TEXT (not pure black)
  Color get textPrimary => isDarkMode ? Colors.white : const Color(0xFF2D2D2D);

  // ✅ WARM GRAY SECONDARY TEXT
  Color get textSecondary =>
      isDarkMode ? Colors.grey.withValues(alpha: 0.7) : const Color(0xFF6B6B6B);

  // ✅ LIGHTER WARM GRAY TERTIARY TEXT
  Color get textTertiary =>
      isDarkMode ? Colors.grey.withValues(alpha: 0.5) : const Color(0xFF999999);

  // ==================== ACCENT COLORS ====================

  Color get accentColor =>
      const Color(0xFFFFD700); // Gold/Yellow - same in both themes

  Color get sectionHeaderColor =>
      isDarkMode ? const Color(0xFFFFD700) : const Color(0xFFD4A017);

  // ==================== BUTTON COLORS ====================

  // ✅ WARMER BUTTON COLOR FOR LIGHT THEME
  Color get buttonPrimary =>
      isDarkMode ? const Color(0xFF808080) : const Color(0xFFB8ADA0);

  Color get buttonTextColor => Colors.white;

  Color get buttonDanger =>
      isDarkMode ? const Color(0xFF808080) : const Color(0xFFFFFBF5);

  Color get buttonDangerText => Colors.red;

  // ==================== ICON COLORS ====================

  // ✅ SOFTER DARK ICONS
  Color get iconPrimary => isDarkMode ? Colors.white : const Color(0xFF3A3A3A);

  Color get iconBlue =>
      const Color(0xFF0000FF); // Blue icons (same in both themes)

  Color get iconGold =>
      const Color(0xFFFFD700); // Gold icons (same in both themes)

  // ==================== TOGGLE/SWITCH COLORS ====================

  Color get toggleActive => const Color(0xFFFFD700);

  Color get toggleActiveTrack => const Color(0xFFFFD700).withValues(alpha: 0.5);

  Color get toggleInactive =>
      isDarkMode ? Colors.grey : const Color(0xFFCCCCCC);

  Color get toggleInactiveTrack =>
      isDarkMode ? Colors.grey.withValues(alpha: 0.3) : const Color(0xFFE5E0DA);

  // ==================== BOTTOM NAVIGATION ====================

  Color get bottomNavSelected =>
      isDarkMode ? const Color(0xFFFFD700) : const Color(0xFFFFE5B4);

  Color get bottomNavUnselected =>
      isDarkMode ? Colors.white : const Color(0xFF3A3A3A);

  Color get bottomNavBackground =>
      isDarkMode ? const Color(0xFF1a1a1a) : const Color(0xFFFAF6F0);

  // ==================== DIVIDER & BORDERS ====================

  // ✅ WARMER DIVIDERS AND BORDERS
  Color get dividerColor => isDarkMode
      ? Colors.white.withValues(alpha: 0.1)
      : const Color(0xFFE5DED5);

  Color get borderColor => isDarkMode
      ? Colors.white.withValues(alpha: 0.2)
      : const Color(0xFFE5DED5);

  // ==================== SPECIAL COLORS ====================

  // ✅ WARMER SHIMMER COLORS
  Color get shimmerBase =>
      isDarkMode ? const Color(0xFF2a2a2a) : const Color(0xFFF0EBE3);

  Color get shimmerHighlight =>
      isDarkMode ? const Color(0xFF3a3a3a) : const Color(0xFFFFFBF5);

  // ==================== DIALOG COLORS ====================

  // ✅ WARM DIALOG BACKGROUND
  Color get dialogBackground =>
      isDarkMode ? const Color(0xFF2a2a2a) : const Color(0xFFFFFBF5);

  Color get dialogTextColor =>
      isDarkMode ? Colors.white : const Color(0xFF2D2D2D);

  // ==================== SHADOW ====================

  BoxShadow get cardShadow => BoxShadow(
    color: isDarkMode
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.08),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );
}
