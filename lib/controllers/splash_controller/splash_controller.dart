import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../core/routes/app_routes.dart';
import '../auth_controller/auth_controller.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('🎨 SPLASH CONTROLLER INITIALIZED');
    _navigateToNextScreen();
  }
  
  /// Wait 2 seconds then navigate based on state
  Future<void> _navigateToNextScreen() async {
    print('⏳ Waiting 2 seconds...');
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      final authController = Get.find<AuthController>();
      
      if (authController.isLoggedIn) {
        // User is logged in - go to main app
        print('✅ User is logged in - going to main');
        Get.offAllNamed(AppRoutes.main);
      } else {
        // User is NOT logged in - show user onboarding
        // ✅ We ALWAYS show onboarding for signed-out users (no purple login page)
        print('🎬 User not logged in - showing user onboarding');
        Get.offAllNamed(AppRoutes.userOnboarding);
      }
    } catch (e) {
      print('❌ Error in navigation: $e');
      // Fallback to user onboarding
      Get.offAllNamed(AppRoutes.userOnboarding);
    }
  }
}