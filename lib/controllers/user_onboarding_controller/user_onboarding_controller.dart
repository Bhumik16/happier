import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../core/routes/app_routes.dart';
import '../auth_controller/auth_controller.dart';

class UserOnboardingController extends GetxController {
  final Logger _logger = Logger();

  // Current page
  final RxInt currentPage = 0.obs;
  final PageController pageController = PageController();

  // Step 1: How did you hear about us?
  final RxList<String> selectedSources = <String>[].obs;
  final RxString otherSourceText = ''.obs;
  final List<String> sourceOptions = [
    'Therapist/Mental Health Professional',
    'Ad: Social Media',
    'Browsing the Play Store',
    'Influencer',
    'Good Morning America',
    'A book by Dan Harris',
    'YouTube',
    'Podcast',
    'A friend/family member',
    'Other',
  ];

  // Step 2: Do you meditate?
  final RxString meditationExperience = ''.obs;
  final List<String> experienceOptions = ['Nope', 'Tried it', 'Regularly'];

  // Step 3: What goal brings you?
  final RxString selectedGoal = ''.obs;
  final Map<String, Map<String, dynamic>> goals = {
    'Sleep Better': {
      'icon': Icons.nightlight_round,
      'description':
          'Relax your mind and body, falling into a deep and restful sleep.',
    },
    'Relax More': {
      'icon': Icons.airline_seat_flat,
      'description':
          'Ease tension and calm your thoughts for a peaceful and serene state of mind.',
    },
    'Reduce Stress': {
      'icon': Icons.favorite,
      'description':
          'Alleviate pressure and anxiety, fostering a sense of calm and tranquility.',
    },
    'Self Discovery': {
      'icon': Icons.search,
      'description':
          'Explore your inner world, uncovering personal insights and authentic self.',
    },
    'More Balance': {
      'icon': Icons.balance,
      'description':
          'Find your center and achieve a harmonious equilibrium in your daily life.',
    },
    'Self Compassion': {
      'icon': Icons.self_improvement,
      'description':
          'Cultivate kindness towards yourself, embracing imperfections with understanding.',
    },
  };

  // Step 4: When to meditate?
  final RxString meditationTime = 'Evening'.obs;
  final RxString reminderTime = '7:00 PM'.obs;
  final List<String> timeOptions = ['Morning', 'Mid-Day', 'Evening'];

  // Progress
  double get progress => (currentPage.value + 1) / 6;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Navigation
  void nextPage() {
    if (currentPage.value < 5) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    // Skip to summary page
    currentPage.value = 5;
    pageController.animateToPage(
      5,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Validation
  bool canContinueFromPage(int page) {
    switch (page) {
      case 0:
        return selectedSources.isNotEmpty &&
            (!selectedSources.contains('Other') ||
                otherSourceText.value.isNotEmpty);
      case 1:
        return meditationExperience.value.isNotEmpty;
      case 2:
        return selectedGoal.value.isNotEmpty;
      case 3:
        return meditationTime.value.isNotEmpty;
      default:
        return true;
    }
  }

  // Save preferences and trigger Google sign-in directly
  Future<void> savePreferencesAndTriggerGoogleSignIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Mark that user has seen onboarding AND completed it
      await prefs.setBool('hasSeenOnboarding', true);
      await prefs.setBool('hasCompletedOnboarding', true);
      _logger.i('✅ Set onboarding flags to true');

      // Save their preferences
      if (meditationExperience.value.isNotEmpty) {
        await prefs.setString(
          'meditationExperience',
          meditationExperience.value,
        );
      }
      if (selectedGoal.value.isNotEmpty) {
        await prefs.setString('meditationGoal', selectedGoal.value);
      }
      if (meditationTime.value.isNotEmpty) {
        await prefs.setString('meditationTime', meditationTime.value);
      }
      if (reminderTime.value.isNotEmpty) {
        await prefs.setString('reminderTime', reminderTime.value);
      }

      _logger.i('✅ Preferences saved, triggering Google sign-in');

      // Get AuthController and trigger Google sign-in
      final authController = Get.find<AuthController>();
      await authController.signInWithGoogle();
    } catch (e) {
      _logger.e('❌ Error: $e');
      Get.snackbar(
        'Error',
        'Failed to sign in. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF2a2a2a),
        colorText: Colors.white,
      );
    }
  }

  // Selection methods
  void toggleSource(String source) {
    if (selectedSources.contains(source)) {
      selectedSources.remove(source);
    } else {
      selectedSources.add(source);
    }
  }

  void selectExperience(String experience) {
    meditationExperience.value = experience;
  }

  void selectGoal(String goal) {
    selectedGoal.value = goal;
  }

  void selectTime(String time) {
    meditationTime.value = time;
  }

  void updateReminderTime(String time) {
    reminderTime.value = time;
  }
}
