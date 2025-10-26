import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/premium_upgrade_controller/premium_upgrade_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/utils/navigation_helper.dart'; // ✅ ADDED

class PremiumUpgradeView extends GetView<PremiumUpgradeController> {
  const PremiumUpgradeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        final theme = appearanceController.theme;
        
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // Close button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.close, color: theme.iconPrimary, size: 28),
                    onPressed: () => NavigationHelper.goBack(context), // ✅ FIXED
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Hero Image Section
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Content Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              // Title
                              Text(
                                'Upgrade to Premium',
                                style: TextStyle(
                                  color: theme.textPrimary,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Description
                              Text(
                                'Get unlimited offline access to the world\'s best meditation teachers and scientists.',
                                style: TextStyle(
                                  color: theme.textSecondary,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 40),
                              
                              // Pricing Cards
                              Obx(() => Row(
                                children: [
                                  // Monthly Plan
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: controller.selectMonthly,
                                      child: Container(
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: controller.selectedPlan.value == 'monthly'
                                              ? theme.accentColor
                                              : theme.cardColor,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Monthly',
                                              style: TextStyle(
                                                color: controller.selectedPlan.value == 'monthly'
                                                    ? Colors.black
                                                    : theme.textPrimary,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              '₹1300.00',
                                              style: TextStyle(
                                                color: controller.selectedPlan.value == 'monthly'
                                                    ? Colors.black
                                                    : theme.textPrimary,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '/mo',
                                              style: TextStyle(
                                                color: controller.selectedPlan.value == 'monthly'
                                                    ? Colors.black54
                                                    : theme.textSecondary,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'billed monthly',
                                              style: TextStyle(
                                                color: controller.selectedPlan.value == 'monthly'
                                                    ? Colors.black87
                                                    : theme.textSecondary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 16),
                                  
                                  // Yearly Plan
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: controller.selectYearly,
                                      child: Container(
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: controller.selectedPlan.value == 'yearly'
                                              ? theme.accentColor
                                              : theme.cardColor,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Yearly',
                                              style: TextStyle(
                                                color: controller.selectedPlan.value == 'yearly'
                                                    ? Colors.black
                                                    : theme.textPrimary,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              '₹733.33',
                                              style: TextStyle(
                                                color: controller.selectedPlan.value == 'yearly'
                                                    ? Colors.black
                                                    : theme.textPrimary,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '/mo',
                                              style: TextStyle(
                                                color: controller.selectedPlan.value == 'yearly'
                                                    ? Colors.black54
                                                    : theme.textSecondary,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '₹8800.00 per year',
                                              style: TextStyle(
                                                color: controller.selectedPlan.value == 'yearly'
                                                    ? Colors.black87
                                                    : theme.textSecondary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                              
                              const SizedBox(height: 24),
                              
                              // Recurring billing text
                              Text(
                                'Recurring billing. Cancel anytime.',
                                style: TextStyle(
                                  color: theme.textSecondary,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 40),
                              
                              // Subscribe Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: controller.subscribeToPlan,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.accentColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Subscribe Now',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
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