import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/auth_service.dart';
import '../../core/routes/app_routes.dart';

/// ==========================================
/// AUTH CONTROLLER
/// ==========================================
/// Manages authentication state and operations
class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final Logger _logger = Logger();

  // Reactive states
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final RxBool _isLoading = false.obs;

  // Getters
  User? get user => _firebaseUser.value;
  bool get isLoggedIn => _firebaseUser.value != null;
  bool get isLoading => _isLoading.value;
  String get userName => user?.displayName ?? 'User';
  String get userEmail => user?.email ?? '';
  String get userPhotoUrl => user?.photoURL ?? '';

  @override
  void onInit() {
    super.onInit();
    _logger.i('🔐 AuthController initialized');

    // Listen to auth state changes
    _firebaseUser.bindStream(_authService.authStateChanges);

    // React to auth changes
    ever(_firebaseUser, _handleAuthChanged);
  }

  /// Handle authentication state changes
  Future<void> _handleAuthChanged(User? user) async {
    if (user == null) {
      _logger.i('👤 User is signed out');

      // ✅ Only navigate to onboarding if not already there or on splash
      if (Get.currentRoute != AppRoutes.userOnboarding &&
          Get.currentRoute != AppRoutes.splash) {
        _logger.i('🎬 Showing user onboarding');
        Get.offAllNamed(AppRoutes.userOnboarding);
      }
    } else {
      _logger.i('👤 User is signed in: ${user.email}');

      // ✅ Navigate to main if coming from onboarding (after login)
      // Let SplashController handle navigation if we're on splash
      if (Get.currentRoute == AppRoutes.userOnboarding) {
        _logger.i('✅ Going to main app after login');
        Get.offAllNamed(AppRoutes.main);
      } else if (Get.currentRoute == AppRoutes.splash) {
        _logger.i(
          'ℹ️ On splash screen, letting SplashController handle navigation',
        );
      } else if (Get.currentRoute == AppRoutes.main) {
        _logger.i('ℹ️ Already on main screen');
      } else {
        _logger.i('ℹ️ User already logged in, staying on ${Get.currentRoute}');
      }
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      _isLoading.value = true;
      _logger.i('🔐 Signing in with Google...');

      await _authService.signInWithGoogle();

      Get.snackbar(
        '✅ Success',
        'Welcome, $userName!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _logger.e('❌ Sign-in error: $e');
      Get.snackbar(
        '❌ Error',
        'Failed to sign in. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      _logger.i('👋 Signing out...');

      // ✅ CLEAR onboarding flags so user sees onboarding again
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('hasSeenOnboarding');
      await prefs.remove('hasCompletedOnboarding');
      _logger.i('🧹 Cleared onboarding flags');

      await _authService.signOut();

      Get.snackbar(
        '👋 Goodbye',
        'You have been signed out',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _logger.e('❌ Sign-out error: $e');
      Get.snackbar(
        '❌ Error',
        'Failed to sign out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
