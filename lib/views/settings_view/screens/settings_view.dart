import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/settings_controller/settings_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/utils/navigation_helper.dart'; // ✅ ADDED

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure AppearanceController is initialized
    if (!Get.isRegistered<AppearanceController>()) {
      Get.put(AppearanceController());
    }
    
    final AppTheme theme = AppTheme();
    
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
            backgroundColor: theme.appBarColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.iconPrimary),
              onPressed: () => NavigationHelper.goBack(context), // ✅ FIXED
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ListView(
            children: [
              // Membership Section
              _buildSectionHeader('Membership', theme),
              _buildMenuItem(
                title: 'Account',
                onTap: controller.onAccountTap,
                theme: theme,
              ),
              _buildMenuItem(
                title: 'Subscription',
                onTap: controller.onSubscriptionTap,
                theme: theme,
              ),

              const SizedBox(height: 20),

              // Manage Section
              _buildSectionHeader('Manage', theme),
              _buildMenuItem(
                title: 'Notifications',
                onTap: controller.onNotificationsTap,
                theme: theme,
              ),
              _buildMenuItem(
                title: 'Downloads',
                onTap: controller.onDownloadsTap,
                theme: theme,
              ),
              _buildMenuItem(
                title: 'Appearance',
                onTap: controller.onAppearanceTap,
                theme: theme,
              ),

              const SizedBox(height: 20),

              // Support Section
              _buildSectionHeader('Support', theme),
              _buildMenuItem(
                title: 'Meditation FAQ',
                onTap: controller.onMeditationFAQTap,
                theme: theme,
              ),
              _buildMenuItem(
                title: 'Support Center',
                onTap: controller.onSupportCenterTap,
                theme: theme,
              ),
              _buildMenuItem(
                title: 'Contact a Human',
                onTap: controller.onContactHumanTap,
                theme: theme,
              ),

              const SizedBox(height: 20),

              // Happier Section
              _buildSectionHeader('Happier', theme),
              _buildMenuItem(
                title: 'Share Happier',
                onTap: controller.onShareHappierTap,
                theme: theme,
              ),
              _buildMenuItem(
                title: 'Rate the App',
                onTap: controller.onRateAppTap,
                theme: theme,
              ),

              const SizedBox(height: 20),

              // About Section
              _buildSectionHeader('About', theme),
              _buildMenuItem(
                title: 'Privacy Policy',
                onTap: controller.onPrivacyPolicyTap,
                theme: theme,
              ),
              _buildMenuItem(
                title: 'Terms of Service',
                onTap: controller.onTermsOfServiceTap,
                theme: theme,
              ),

              // App Version
              Padding(
                padding: const EdgeInsets.all(20),
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Version',
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.appVersion.value}.${controller.buildNumber.value}',
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Text(
        title,
        style: TextStyle(
          color: theme.sectionHeaderColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
    required AppTheme theme,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.textSecondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}