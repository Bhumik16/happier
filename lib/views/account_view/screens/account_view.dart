import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/account_controller/account_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/utils/navigation_helper.dart'; // ✅ ADDED

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

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
              'Account',
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
                
                // Name
                Text(
                  'Name',
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.userName,
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Email
                Text(
                  'Email',
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.userEmail,
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Login Method
                Text(
                  'Login Method',
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.loginMethod,
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Sign Out Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.signOut,
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
                      'Sign Out',
                      style: TextStyle(
                        color: theme.isDark ? Colors.white : Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Delete Account Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.deleteAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.isDark 
                          ? const Color(0xFF808080) 
                          : const Color(0xFFB8B8B8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Delete My Account',
                      style: TextStyle(
                        color: Colors.red,
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