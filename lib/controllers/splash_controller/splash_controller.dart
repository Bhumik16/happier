import 'package:get/get.dart';
import 'package:logger/logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../core/routes/app_routes.dart';
import '../auth_controller/auth_controller.dart';

class SplashController extends GetxController {
  final Logger _logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _logger.i('🎨 SPLASH CONTROLLER INITIALIZED');
    _navigateToNextScreen();
  }

  /// Wait 2 seconds then navigate based on state
  Future<void> _navigateToNextScreen() async {
    _logger.d('⏳ Waiting 2 seconds...');
    await Future.delayed(const Duration(seconds: 2));

    try {
      final authController = Get.find<AuthController>();

      if (authController.isLoggedIn) {
        // User is logged in - go to main app
        _logger.i('✅ User is logged in - going to main');
        Get.offAllNamed(AppRoutes.main);
      } else {
        // User is NOT logged in - show user onboarding
        // ✅ We ALWAYS show onboarding for signed-out users (no purple login page)
        _logger.i('🎬 User not logged in - showing user onboarding');
        Get.offAllNamed(AppRoutes.userOnboarding);
      }
    } catch (e) {
      _logger.e('❌ Error in navigation: $e');
      // Fallback to user onboarding
      Get.offAllNamed(AppRoutes.userOnboarding);
    }
  }
}
