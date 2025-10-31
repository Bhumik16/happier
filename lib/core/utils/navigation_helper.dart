import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../routes/app_routes.dart';

class NavigationHelper {
  static final Logger _logger = Logger();

  // ✅ IMPROVED: Universal back navigation that ALWAYS works
  static void goBack(BuildContext context) {
    try {
      _logger.d('🔙 Attempting navigation back...');

      // Method 1: Check if we can use GetX back (most reliable with GetX routing)
      if (Get.key.currentState?.canPop() ?? false) {
        _logger.i('✅ Using GetX navigation');
        Get.back();
        return;
      }

      // Method 2: Try native Flutter navigation
      if (Navigator.of(context).canPop()) {
        _logger.i('✅ Using Navigator.pop');
        Navigator.of(context).pop();
        return;
      }

      // Method 3: If nothing works, go to main
      _logger.w('⚠️ Fallback to main screen');
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      _logger.e('❌ Navigation error: $e');
      // Emergency fallback
      try {
        Get.offAllNamed(AppRoutes.main);
      } catch (e2) {
        _logger.e('❌ Critical navigation error: $e2');
      }
    }
  }

  // ✅ Simpler alternative that doesn't require context
  static void goBackSimple() {
    try {
      if (Get.key.currentState?.canPop() ?? false) {
        Get.back();
      } else {
        Get.offAllNamed(AppRoutes.main);
      }
    } catch (e) {
      _logger.e('❌ Navigation error: $e');
      Get.offAllNamed(AppRoutes.main);
    }
  }
}
