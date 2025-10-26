import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user_onboarding_controller/user_onboarding_controller.dart';

class UserOnboardingView extends GetView<UserOnboardingController> {
  const UserOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Obx(() {
              final progress = controller.progress;
              return Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(2),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDB813),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  },
                ),
              );
            }),
            
            // Page view
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => controller.currentPage.value = index,
                children: [
                  _buildWelcomePage(),
                  _SourceSelectionPage(),
                  _ExperiencePage(),
                  _GoalPage(),
                  _TimePage(),
                  _SummaryPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // PAGE 1: WELCOME
  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Spacer(),
          
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.celebration,
              size: 100,
              color: Color(0xFFFDB813),
            ),
          ),
          
          const SizedBox(height: 40),
          
          const Text(
            'Learn to live in the moment, even when you don\'t have a moment with guidance from our trusted teachers.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.5,
            ),
          ),
          
          const Spacer(),
          
          _buildPrimaryButton(
            text: 'Get Started',
            onTap: () => controller.nextPage(),
          ),
          
          const SizedBox(height: 16),
          
          GestureDetector(
            onTap: () => controller.skipOnboarding(),
            child: RichText(
              text: const TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                children: [
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({required String text, required VoidCallback? onTap}) {
    final isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isEnabled ? const Color(0xFFF5EDD1) : const Color(0xFF3a3a3a),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isEnabled ? Colors.black : Colors.grey[600],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  Widget _buildTextButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}

// ========================================
// PAGE 2: SOURCE SELECTION (✅ FIXED BOX HEIGHTS)
// ========================================
class _SourceSelectionPage extends GetView<UserOnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'How did you hear about\nHappier Meditation?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 30),
          
          Expanded(
            child: ListView.builder(
              itemCount: controller.sourceOptions.length,
              itemBuilder: (context, index) {
                final source = controller.sourceOptions[index];
                return Obx(() {
                  final isSelected = controller.selectedSources.contains(source);
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => controller.toggleSource(source),
                        child: Container(
                          height: 56, // ✅ FIXED HEIGHT
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2a2a2a),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFFDB813) : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            source,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      if (source == 'Other' && isSelected) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: TextField(
                            onChanged: (value) => controller.otherSourceText.value = value,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'We\'d love to know!',
                              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                              filled: true,
                              fillColor: const Color(0xFF2a2a2a),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                    ],
                  );
                });
              },
            ),
          ),
          
          Obx(() {
            final canContinue = controller.canContinueFromPage(0);
            return _buildPrimaryButton(
              text: 'Continue',
              onTap: canContinue ? () => controller.nextPage() : null,
            );
          }),
          
          const SizedBox(height: 12),
          _buildTextButton(text: 'Skip for Now', onTap: () => controller.nextPage()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({required String text, required VoidCallback? onTap}) {
    final isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isEnabled ? const Color(0xFFF5EDD1) : const Color(0xFF3a3a3a),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isEnabled ? Colors.black : Colors.grey[600],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  Widget _buildTextButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 16)),
      ),
    );
  }
}

// ========================================
// PAGE 3: EXPERIENCE
// ========================================
class _ExperiencePage extends GetView<UserOnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text('Do you meditate?', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('This helps us personalize your experience.', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const Spacer(),
          
          ...controller.experienceOptions.map((experience) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Obx(() {
                final isSelected = controller.meditationExperience.value == experience;
                return GestureDetector(
                  onTap: () => controller.selectExperience(experience),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2a2a2a),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFDB813) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      experience,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              }),
            );
          }).toList(),
          
          const Spacer(),
          
          Obx(() {
            final canContinue = controller.canContinueFromPage(1);
            return _buildPrimaryButton(
              text: 'Continue',
              onTap: canContinue ? () => controller.nextPage() : null,
            );
          }),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({required String text, required VoidCallback? onTap}) {
    final isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isEnabled ? const Color(0xFFF5EDD1) : const Color(0xFF3a3a3a),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: isEnabled ? Colors.black : Colors.grey[600], fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ========================================
// PAGE 4: GOAL
// ========================================
class _GoalPage extends GetView<UserOnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'What goal brings\nyou to Happier?',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const SizedBox(height: 30),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: controller.goals.length,
              itemBuilder: (context, index) {
                final goal = controller.goals.keys.elementAt(index);
                final goalData = controller.goals[goal]!;
                return Obx(() {
                  final isSelected = controller.selectedGoal.value == goal;
                  return GestureDetector(
                    onTap: () => controller.selectGoal(goal),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2a2a2a),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFFDB813) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(goalData['icon'] as IconData, color: Colors.grey[600], size: 60),
                          const SizedBox(height: 16),
                          Text(goal, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          
          Obx(() {
            if (controller.selectedGoal.value.isNotEmpty) {
              final description = controller.goals[controller.selectedGoal.value]!['description'] as String;
              return Column(
                children: [
                  const SizedBox(height: 16),
                  Text(description, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400], fontSize: 14, height: 1.5)),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
          
          const SizedBox(height: 20),
          
          Obx(() {
            final canContinue = controller.canContinueFromPage(2);
            return _buildPrimaryButton(
              text: 'Continue',
              onTap: canContinue ? () => controller.nextPage() : null,
            );
          }),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({required String text, required VoidCallback? onTap}) {
    final isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isEnabled ? const Color(0xFFF5EDD1) : const Color(0xFF3a3a3a),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: isEnabled ? Colors.black : Colors.grey[600], fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ========================================
// PAGE 5: TIME (✅ WORKING TIME PICKER)
// ========================================
class _TimePage extends GetView<UserOnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'When do you want\nto meditate?',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const Spacer(),
          
          Row(
            children: controller.timeOptions.map((time) {
              IconData icon;
              if (time == 'Morning') icon = Icons.wb_sunny_outlined;
              else if (time == 'Mid-Day') icon = Icons.wb_sunny;
              else icon = Icons.nightlight_round;
              
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Obx(() {
                    final isSelected = controller.meditationTime.value == time;
                    return GestureDetector(
                      onTap: () => controller.selectTime(time),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2a2a2a),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFDB813) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(icon, color: Colors.grey[600], size: 40),
                            const SizedBox(height: 12),
                            Text(time, style: const TextStyle(color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 40),
          const Text('We\'ll remind you at...', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 16),
          
          // ✅ WORKING TIME PICKER
          Obx(() => GestureDetector(
            onTap: () => _showTimePicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2a2a2a),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(controller.reminderTime.value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ],
              ),
            ),
          )),
          
          const Spacer(),
          
          _buildPrimaryButton(text: 'Set Reminder', onTap: () => controller.nextPage()),
          const SizedBox(height: 12),
          _buildTextButton(text: 'Skip for Now', onTap: () => controller.nextPage()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ✅ PROPER TIME PICKER MODAL
  void _showTimePicker(BuildContext context) async {
    // Parse current time
    final currentTime = controller.reminderTime.value;
    final parts = currentTime.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final String period = parts[1]; // AM or PM
    
    // Convert to 24-hour for TimeOfDay
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }
    
    // Show native time picker
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFDB813), // Yellow
              onPrimary: Colors.black,
              surface: Color(0xFF2a2a2a),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1a1a1a),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: const Color(0xFF1a1a1a),
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF2a2a2a)),
              ),
              dayPeriodBorderSide: const BorderSide(color: Color(0xFFFDB813)),
              dayPeriodColor: const Color(0xFFFDB813),
              dayPeriodTextColor: Colors.black,
              dialHandColor: const Color(0xFFFDB813),
              dialBackgroundColor: const Color(0xFF2a2a2a),
              hourMinuteColor: const Color(0xFF2a2a2a),
              hourMinuteTextColor: Colors.white,
              dialTextColor: Colors.white,
              entryModeIconColor: const Color(0xFFFDB813),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedTime != null) {
      // Format time to 12-hour format with AM/PM
      final hour12 = pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod;
      final minute = pickedTime.minute.toString().padLeft(2, '0');
      final period = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
      
      final formattedTime = '$hour12:$minute $period';
      controller.updateReminderTime(formattedTime);
    }
  }

  Widget _buildPrimaryButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EDD1),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
  
  Widget _buildTextButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 16)),
      ),
    );
  }
}

// ========================================
// PAGE 6: SUMMARY (✅ DIRECT GOOGLE SIGN-IN)
// ========================================
class _SummaryPage extends GetView<UserOnboardingController> {
  @override
  Widget build(BuildContext context) {
    // Read values ONCE
    final experience = controller.meditationExperience.value;
    final goal = controller.selectedGoal.value;
    final time = controller.meditationTime.value;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Great, let\'s save your\npreferences.',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const Spacer(),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2a2a2a),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                if (experience.isNotEmpty)
                  _buildSummaryItem(
                    icon: Icons.person_outline,
                    title: 'When it comes to meditation',
                    value: 'You\'ve $experience',
                  ),
                if (experience.isNotEmpty && goal.isNotEmpty)
                  const Divider(color: Colors.grey, height: 40),
                if (goal.isNotEmpty)
                  _buildSummaryItem(
                    icon: controller.goals[goal]!['icon'] as IconData,
                    title: 'You\'d like to',
                    value: goal,
                  ),
                if (goal.isNotEmpty && time.isNotEmpty)
                  const Divider(color: Colors.grey, height: 40),
                if (time.isNotEmpty)
                  _buildSummaryItem(
                    icon: Icons.nightlight_round,
                    title: 'You\'re going to meditate',
                    value: 'In the $time',
                  ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // ✅ DIRECT GOOGLE SIGN-IN
          _buildLoginButton(
            icon: 'https://www.google.com/images/branding/googleg/1x/googleg_standard_color_128dp.png',
            text: 'Continue with Google',
            onTap: () => controller.savePreferencesAndTriggerGoogleSignIn(),
          ),
          const SizedBox(height: 16),
          _buildLoginButton(
            text: 'Continue with Email',
            onTap: () => controller.savePreferencesAndTriggerGoogleSignIn(),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => controller.savePreferencesAndTriggerGoogleSignIn(),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                children: [
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 40),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildLoginButton({String? icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EDD1),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Image.network(icon, height: 24, width: 24),
              const SizedBox(width: 12),
            ],
            Text(text, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}