import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;
import '../../core/routes/app_routes.dart';

class SettingsController extends GetxController {
  final RxString appVersion = ''.obs;
  final RxString buildNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
      buildNumber.value = packageInfo.buildNumber;
    } catch (e) {
      appVersion.value = '1.0.0';
      buildNumber.value = '1';
    }
  }

  // Membership Section
  void onAccountTap() {
    Get.toNamed(AppRoutes.account);
  }

  void onSubscriptionTap() {
    Get.toNamed(AppRoutes.subscription);
  }

  // Manage Section
  void onNotificationsTap() {
    Get.toNamed(AppRoutes.notifications);
  }

  void onDownloadsTap() {
    Get.toNamed(AppRoutes.downloadsSettings);
  }

  void onAppearanceTap() {
    Get.toNamed(AppRoutes.appearance);
  }

  // ==================== SUPPORT SECTION ====================
  
  Future<void> onMeditationFAQTap() async {
    // REAL URL
    await _launchURL('https://www.meditatehappier.com/support/faq');
    
    // DUMMY URL (uncomment if real URL doesn't work)
    // await _launchURL('https://flutter.dev/');
  }

  Future<void> onSupportCenterTap() async {
    // REAL URL
    await _launchURL('https://support.meditatehappier.com/');
    
    // DUMMY URL (uncomment if real URL doesn't work)
    // await _launchURL('https://github.com/');
  }

  Future<void> onContactHumanTap() async {
    // REAL URL - Opens support center
    await _launchURL('https://support.meditatehappier.com/');
    
    // DUMMY URL (uncomment if real URL doesn't work)
    // await _launchURL('https://stackoverflow.com/');
  }

  // ==================== HAPPIER SECTION ====================
  
  Future<void> onShareHappierTap() async {
    // REAL URL
    await _launchURL('https://my.meditatehappier.com/link/download');
    
    // DUMMY URL (uncomment if real URL doesn't work)
    // await _launchURL('https://www.google.com/');
  }

  Future<void> onRateAppTap() async {
    // Platform-specific app store URLs
    String url;
    try {
      if (Platform.isAndroid) {
        // REAL URL
        url = 'https://play.google.com/store/apps/details?id=com.changecollective.tenpercenthappier';
        
        // DUMMY URL (uncomment if real URL doesn't work)
        // url = 'https://play.google.com/store';
      } else if (Platform.isIOS) {
        // REAL URL
        url = 'https://apps.apple.com/app/id10-happier-meditation/id992210239';
        
        // DUMMY URL (uncomment if real URL doesn't work)
        // url = 'https://apps.apple.com/';
      } else {
        url = 'https://play.google.com/store';
      }
      await _launchURL(url);
    } catch (e) {
      // Fallback
      await _launchURL('https://www.google.com/');
    }
  }

  // ==================== ABOUT SECTION ====================
  
  Future<void> onPrivacyPolicyTap() async {
    // REAL URL
    await _launchURL('https://www.meditatehappier.com/privacy-policy');
    
    // DUMMY URL (uncomment if real URL doesn't work)
    // await _launchURL('https://policies.google.com/privacy');
  }

  Future<void> onTermsOfServiceTap() async {
    // REAL URL
    await _launchURL('https://www.meditatehappier.com/terms-of-service');
    
    // DUMMY URL (uncomment if real URL doesn't work)
    // await _launchURL('https://policies.google.com/terms');
  }

  // ==================== HELPER METHOD ====================
  
  /// Launches URL in external browser
  /// Simplified version without canLaunchUrl check for better compatibility
  Future<void> _launchURL(String urlString) async {
    try {
      print('🔗 Attempting to launch: $urlString');
      
      final url = Uri.parse(urlString);
      
      // Try to launch with platform default mode
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      
      if (launched) {
        print('✅ Successfully launched: $urlString');
      } else {
        print('❌ Failed to launch: $urlString');
        _showErrorSnackbar('Could not open link');
      }
      
    } catch (e) {
      print('❌ Error launching URL: $e');
      _showErrorSnackbar('Failed to open link: $e');
    }
  }
  
  /// Shows error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 3),
    );
  }
}