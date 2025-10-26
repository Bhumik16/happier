import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/downloads_settings_controller/downloads_settings_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/utils/navigation_helper.dart'; // ✅ ADDED

class DownloadsSettingsView extends GetView<DownloadsSettingsController> {
  const DownloadsSettingsView({super.key});

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
              'Downloads',
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
              // Download Only on Wi-Fi
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Download Only on Wi-Fi',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Switch(
                    value: controller.downloadOnlyOnWifi.value,
                    onChanged: controller.toggleDownloadOnlyOnWifi,
                    activeColor: theme.accentColor,
                    activeTrackColor: theme.accentColor.withOpacity(0.5),
                    inactiveThumbColor: theme.isDark ? Colors.grey : const Color(0xFFB8B8B8),
                    inactiveTrackColor: theme.isDark 
                        ? Colors.grey.withOpacity(0.3) 
                        : const Color(0xFFD8D8D8),
                  ),
                ],
              )),
              
              const SizedBox(height: 32),
              
              // Quality
              InkWell(
                onTap: controller.openQualityPicker,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quality',
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                      controller.quality.value,
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 16,
                      ),
                    )),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Happier Meditation Downloads
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Happier Meditation Downloads',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    controller.totalDownloadsSize.value,
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 16,
                    ),
                  )),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Free Space
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Free Space',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    controller.freeSpace.value,
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 16,
                    ),
                  )),
                ],
              ),
              
              const SizedBox(height: 50),
              
              // Remove All Downloads Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.removeAllDownloads,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.isDark 
                        ? const Color(0xFF808080) 
                        : const Color(0xFFB8B8B8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Remove All Downloads',
                    style: TextStyle(
                      color: theme.isDark ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}