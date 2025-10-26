import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsController extends GetxController {
  // Reactive states
  final RxBool dndWhileMeditating = false.obs;
  final RxBool dailyReminder = true.obs;
  final RxString scheduleTime = 'Every day at 7:00 PM'.obs; // Default fallback
  final RxBool streakBreakWarning = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }
  
  // Load saved preferences
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load notification settings
      dndWhileMeditating.value = prefs.getBool('dnd_while_meditating') ?? false;
      dailyReminder.value = prefs.getBool('daily_reminder') ?? true;
      streakBreakWarning.value = prefs.getBool('streak_break_warning') ?? false;
      
      // ✅ LOAD TIME FROM ONBOARDING (if exists)
      final onboardingTime = prefs.getString('reminderTime'); // From user onboarding
      
      if (onboardingTime != null && onboardingTime.isNotEmpty) {
        // User set a time during onboarding - use it!
        scheduleTime.value = 'Every day at $onboardingTime';
        print('✅ Loaded reminder time from onboarding: $onboardingTime');
      } else {
        // Fallback: check if they've set it in notifications page before
        scheduleTime.value = prefs.getString('schedule_time') ?? 'Every day at 7:00 PM';
        print('ℹ️ Using default or previously saved time');
      }
      
      // Schedule notification if daily reminder is enabled
      if (dailyReminder.value) {
        _scheduleDailyReminder();
      }
    } catch (e) {
      print('❌ Error loading notification preferences: $e');
    }
  }
  
  // Toggle DND While Meditating
  Future<void> toggleDndWhileMeditating(bool value) async {
    dndWhileMeditating.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dnd_while_meditating', value);
    
    Get.snackbar(
      'Do Not Disturb',
      value ? 'DND while meditating enabled' : 'DND while meditating disabled',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  // Toggle Daily Reminder
  Future<void> toggleDailyReminder(bool value) async {
    dailyReminder.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);
    
    if (value) {
      _scheduleDailyReminder();
      
      // Extract just the time from "Every day at X:XX PM"
      final timeOnly = scheduleTime.value.replaceAll('Every day at ', '');
      
      Get.snackbar(
        'Daily Reminder',
        'Daily reminder enabled at $timeOnly',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      _cancelDailyReminder();
      Get.snackbar(
        'Daily Reminder',
        'Daily reminder disabled',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
  
  // Toggle Streak Break Warning
  Future<void> toggleStreakBreakWarning(bool value) async {
    streakBreakWarning.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('streak_break_warning', value);
    
    Get.snackbar(
      'Streak Break Warning',
      value ? 'Streak break warning enabled' : 'Streak break warning disabled',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  // Open time picker for schedule
  Future<void> openSchedulePicker() async {
    // Parse current time to set initial time in picker
    TimeOfDay initialTime = const TimeOfDay(hour: 19, minute: 0); // Default 7 PM
    
    try {
      final timeString = scheduleTime.value.replaceAll('Every day at ', '');
      final parts = timeString.split(' ');
      if (parts.length >= 2) {
        final timeParts = parts[0].split(':');
        int hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final period = parts[1]; // AM or PM
        
        // Convert to 24-hour format
        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }
        
        initialTime = TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      print('⚠️ Could not parse time, using default: $e');
    }
    
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFDB813), // Yellow to match app theme
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
    
    if (picked != null) {
      // Format time to 12-hour format
      final hour12 = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      
      final formattedTime = '$hour12:$minute $period';
      scheduleTime.value = 'Every day at $formattedTime';
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('schedule_time', scheduleTime.value);
      await prefs.setString('reminderTime', formattedTime); // ✅ Also update onboarding time
      await prefs.setInt('reminder_hour', picked.hour);
      await prefs.setInt('reminder_minute', picked.minute);
      
      // Reschedule if enabled
      if (dailyReminder.value) {
        _scheduleDailyReminder();
      }
      
      Get.snackbar(
        'Schedule Updated',
        'Daily reminder set for $formattedTime',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
  
  // Schedule daily reminder (placeholder for actual notification)
  void _scheduleDailyReminder() {
    // TODO: Implement actual notification scheduling using flutter_local_notifications
    final timeOnly = scheduleTime.value.replaceAll('Every day at ', '');
    print('📅 Daily reminder scheduled at $timeOnly');
    
    // Example logic:
    // 1. Use flutter_local_notifications to schedule a daily notification
    // 2. Check last app open timestamp in SharedPreferences
    // 3. If user hasn't opened the app today, show notification at scheduled time
    // 4. Cancel notification if user opens the app
  }
  
  // Cancel daily reminder
  void _cancelDailyReminder() {
    // TODO: Cancel scheduled notifications
    print('🚫 Daily reminder cancelled');
  }
}