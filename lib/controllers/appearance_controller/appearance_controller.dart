import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';

class AppearanceController extends GetxController {
  final Logger _logger = Logger();
  final AppTheme _appTheme = AppTheme();

  // Reactive states
  final RxString currentTheme = 'Dark'.obs;

  // Theme mode enum
  static const String themeDark = 'Dark';
  static const String themeLight = 'Light';
  static const String themeSystem = 'Use System Default';

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }

  // Load saved theme preference
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('app_theme') ?? themeDark;
      currentTheme.value = savedTheme;

      // Update theme mode
      _updateThemeMode(savedTheme);
    } catch (e) {
      _logger.e('Error loading theme preference: $e');
      currentTheme.value = themeDark;
      _appTheme.setThemeMode(ThemeMode.dark);
    }
  }

  // Update theme mode based on theme string
  void _updateThemeMode(String theme) {
    switch (theme) {
      case themeDark:
        _appTheme.setThemeMode(ThemeMode.dark);
        break;
      case themeLight:
        _appTheme.setThemeMode(ThemeMode.light);
        break;
      case themeSystem:
        _appTheme.setThemeMode(ThemeMode.system);
        break;
    }
    update(); // Notify all GetBuilder widgets
  }

  // Open theme picker bottom sheet
  Future<void> openThemePicker() async {
    final themes = [themeDark, themeLight, themeSystem];

    await Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: _appTheme.dialogBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Theme',
              style: TextStyle(
                color: _appTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...themes
                .map(
                  (theme) => Obx(
                    () => ListTile(
                      title: Text(
                        theme,
                        style: TextStyle(color: _appTheme.textPrimary),
                      ),
                      trailing: currentTheme.value == theme
                          ? Icon(Icons.check, color: _appTheme.accentColor)
                          : null,
                      onTap: () {
                        selectTheme(theme);
                        Get.back();
                      },
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  // Select theme
  Future<void> selectTheme(String theme) async {
    currentTheme.value = theme;

    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_theme', theme);

    // Update UI
    _updateThemeMode(theme);

    // Show confirmation
    Get.snackbar(
      'Theme Updated',
      'Theme changed to $theme',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _appTheme.cardColor,
      colorText: _appTheme.textPrimary,
      duration: const Duration(seconds: 2),
    );
  }

  // Getters for theme
  AppTheme get theme => _appTheme;
}
