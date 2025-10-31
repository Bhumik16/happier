import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/notifications_controller/notifications_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/utils/navigation_helper.dart'; // ✅ ADDED

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        final theme = appearanceController.theme;

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
              'Notifications',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Do Not Disturb Section
              Text(
                'Do Not Disturb',
                style: TextStyle(
                  color: theme.accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // DND While Meditating
              _buildToggleItem(
                title: 'DND While Meditating',
                value: controller.dndWhileMeditating,
                onChanged: controller.toggleDndWhileMeditating,
                theme: theme,
              ),

              const SizedBox(height: 32),

              // Meditation Section
              Text(
                'Meditation',
                style: TextStyle(
                  color: theme.accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Daily Reminder
              _buildToggleItem(
                title: 'Daily Reminder',
                value: controller.dailyReminder,
                onChanged: controller.toggleDailyReminder,
                theme: theme,
              ),

              const SizedBox(height: 16),

              // Schedule
              Obx(
                () => InkWell(
                  onTap: controller.dailyReminder.value
                      ? controller.openSchedulePicker
                      : null,
                  child: Opacity(
                    opacity: controller.dailyReminder.value ? 1.0 : 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Schedule',
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.scheduleTime.value,
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Streak Section
              Text(
                'Streak',
                style: TextStyle(
                  color: theme.accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Streak Break Warning
              _buildToggleItem(
                title: 'Streak Break Warning',
                value: controller.streakBreakWarning,
                onChanged: controller.toggleStreakBreakWarning,
                theme: theme,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleItem({
    required String title,
    required RxBool value,
    required Function(bool) onChanged,
    required dynamic theme,
  }) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value.value,
            onChanged: onChanged,
            activeColor: theme.accentColor,
            activeTrackColor: theme.accentColor.withValues(alpha: 0.5),
            inactiveThumbColor: theme.isDark
                ? Colors.grey
                : const Color(0xFFB8B8B8),
            inactiveTrackColor: theme.isDark
                ? Colors.grey.withValues(alpha: 0.3)
                : const Color(0xFFD8D8D8),
          ),
        ],
      ),
    );
  }
}
