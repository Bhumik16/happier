import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/subscription_controller/subscription_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/utils/navigation_helper.dart'; // ✅ ADDED

class SubscriptionView extends GetView<SubscriptionController> {
  const SubscriptionView({super.key});

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
              'Subscription',
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
                const SizedBox(height: 20),
                
                // Type Label
                Text(
                  'Type',
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Subscription Type
                Obx(() => Text(
                  controller.subscriptionType.value,
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 16,
                  ),
                )),
                
                const SizedBox(height: 50),
                
                // Unlock Happier Meditation Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.unlockHappierMeditation,
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
                      'Unlock Happier Meditation',
                      style: TextStyle(
                        color: theme.isDark ? Colors.white : Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Restore Purchases Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.restorePurchases,
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
                      'Restore Purchases',
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
          ),
        );
      },
    );
  }
}