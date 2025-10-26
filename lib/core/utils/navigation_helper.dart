import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class NavigationHelper {
  // ✅ IMPROVED: Universal back navigation that ALWAYS works
  static void goBack(BuildContext context) {
    try {
      print('🔙 Attempting navigation back...');
      
      // Method 1: Check if we can use GetX back (most reliable with GetX routing)
      if (Get.key.currentState?.canPop() ?? false) {
        print('✅ Using GetX navigation');
        Get.back();
        return;
      }
      
      // Method 2: Try native Flutter navigation
      if (Navigator.of(context).canPop()) {
        print('✅ Using Navigator.pop');
        Navigator.of(context).pop();
        return;
      }
      
      // Method 3: If nothing works, go to main
      print('⚠️ Fallback to main screen');
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      print('❌ Navigation error: $e');
      // Emergency fallback
      try {
        Get.offAllNamed(AppRoutes.main);
      } catch (e2) {
        print('❌ Critical navigation error: $e2');
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
      print('❌ Navigation error: $e');
      Get.offAllNamed(AppRoutes.main);
    }
  }
}