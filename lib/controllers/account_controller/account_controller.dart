import 'package:flutter/material.dart'; // ✅ ADDED - Required for Colors, AlertDialog, etc.
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import '../auth_controller/auth_controller.dart';

class AccountController extends GetxController {
  final Logger _logger = Logger();

  // Lazy getter for AuthController - ensures it exists
  AuthController get _authController {
    if (!Get.isRegistered<AuthController>()) {
      _logger.w('⚠️ AuthController not found, creating it...');
      Get.put(AuthController(), permanent: true);
    }
    return Get.find<AuthController>();
  }

  // Getters for user info
  String get userName => _authController.userName;
  String get userEmail => _authController.userEmail;
  String get loginMethod {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.providerData.isNotEmpty == true) {
      final providerId = user!.providerData.first.providerId;
      if (providerId.contains('google')) return 'Google';
      if (providerId.contains('apple')) return 'Apple';
      if (providerId.contains('password')) return 'Email';
    }
    return 'Unknown';
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _logger.i('🔐 Sign out button pressed');

      final confirm = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _logger.i('❌ Sign out cancelled');
                Get.back(result: false);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                _logger.i('✅ Sign out confirmed');
                Get.back(result: true);
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

      if (confirm == true) {
        _logger.i('🚀 Calling AuthController.signOut()...');
        await _authController.signOut();
        _logger.i('✅ Sign out completed successfully');
      } else {
        _logger.i('ℹ️ User cancelled sign out');
      }
    } catch (e, stackTrace) {
      _logger.e('❌ Sign out error: $e');
      _logger.e('Stack trace: $stackTrace');

      Get.snackbar(
        '❌ Error',
        'Failed to sign out: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Delete user account from Firebase
        await FirebaseAuth.instance.currentUser?.delete();

        Get.snackbar(
          'Account Deleted',
          'Your account has been permanently deleted',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to delete account. Please sign in again and try.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
