import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/utils/navigation_helper.dart'; // ✅ ADDED

class AppearanceView extends GetView<AppearanceController> {
  const AppearanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppearanceController>(
      builder: (controller) {
        final theme = controller.theme;
        
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
              'Appearance',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                
                // Theme Section
                InkWell(
                  onTap: controller.openThemePicker,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme',
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                        controller.currentTheme.value,
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 16,
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}