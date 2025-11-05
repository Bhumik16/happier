import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/routes/app_routes.dart';
import '../auth_controller/auth_controller.dart';

class SplashController extends GetxController {
  final Logger _logger = Logger();
  bool _hasNavigated = false; // Prevent multiple navigations

  @override
  void onInit() {
    super.onInit();
    _logger.i('🎨 SPLASH CONTROLLER INITIALIZED');
    _navigateToNextScreen();

    // ✅ SAFETY: Force navigation after 5 seconds no matter what
    Future.delayed(const Duration(seconds: 5), () {
      if (!_hasNavigated) {
        _logger.e('⚠️ TIMEOUT: Forcing navigation to main app');
        _hasNavigated = true;
        Get.offAllNamed(AppRoutes.main);
      }
    });
  }

  /// Wait 2 seconds then navigate based on state
  Future<void> _navigateToNextScreen() async {
    if (_hasNavigated) return; // Already navigated

    _logger.d('⏳ Waiting 2 seconds...');
    await Future.delayed(const Duration(seconds: 2));

    if (_hasNavigated) return; // Check again after delay

    try {
      _logger.i('🔍 Checking auth state and onboarding status...');

      // Check SharedPreferences for onboarding status
      final prefs = await SharedPreferences.getInstance();
      final hasCompletedOnboarding =
          prefs.getBool('hasCompletedOnboarding') ?? false;

      _logger.i('📋 Has completed onboarding: $hasCompletedOnboarding');

      // Try to get auth controller
      AuthController? authController;
      try {
        authController = Get.find<AuthController>();
        _logger.i('✅ AuthController found');
      } catch (e) {
        _logger.w('⚠️ AuthController not found: $e');
      }

      final isLoggedIn = authController?.isLoggedIn ?? false;
      _logger.i('🔐 Is logged in: $isLoggedIn');

      // Decision logic:
      // 1. If user has completed onboarding before, go to main (they'll be auto-logged in by Firebase)
      // 2. If user has NOT completed onboarding, show onboarding
      if (hasCompletedOnboarding) {
        // User has logged in before - go to main app
        _logger.i('✅ User has completed onboarding before - going to main');
        _hasNavigated = true;
        Get.offAllNamed(AppRoutes.main);
      } else {
        // First time user OR user signed out - show onboarding
        _logger.i('🎬 New user or signed out - showing user onboarding');
        _hasNavigated = true;
        Get.offAllNamed(AppRoutes.userOnboarding);
      }
    } catch (e) {
      _logger.e('❌ Error in navigation: $e');
      // ✅ ALWAYS navigate somewhere - don't get stuck!
      if (!_hasNavigated) {
        _logger.i('🚀 Fallback: Going to main app');
        _hasNavigated = true;
        Get.offAllNamed(AppRoutes.main);
      }
    }
  }
}
