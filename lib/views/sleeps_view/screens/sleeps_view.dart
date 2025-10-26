import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common_widgets/sleep_card.dart';
import '../../../controllers/sleeps_controller/sleeps_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';

/// ====================
/// SLEEPS VIEW
/// ====================
/// 
/// Main screen for Sleep tab

class SleepsView extends StatelessWidget {
  const SleepsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SleepsController>();
    final AppTheme theme = AppTheme();
    
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: SafeArea(
            child: Obx(() {
              if (controller.isLoading) {
                return _buildLoadingView(theme);
              }
              
              if (controller.errorMessage.isNotEmpty) {
                return _buildErrorView(controller, theme);
              }
              
              return RefreshIndicator(
                onRefresh: controller.refreshSleeps,
                color: theme.accentColor,
                backgroundColor: theme.cardColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHeader(context, controller, theme),
                      
                      const SizedBox(height: 20),
                      
                      // Featured Section
                      _buildFeaturedSection(controller, theme),
                      
                      const SizedBox(height: 30),
                      
                      // Meditations Section
                      _buildMeditationsSection(controller, theme),
                      
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
  
  // ====================
  // HEADER (WITHOUT ICONS)
  // ====================
  
  Widget _buildHeader(BuildContext context, SleepsController controller, AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Sleep',
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  // ====================
  // FEATURED SECTION
  // ====================
  
  Widget _buildFeaturedSection(SleepsController controller, AppTheme theme) {
    if (controller.featuredSleeps.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Featured',
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.featuredSleeps.length,
            itemBuilder: (context, index) {
              final sleep = controller.featuredSleeps[index];
              return SleepCard(
                sleep: sleep,
                onTap: () => controller.onSleepTap(sleep),
              );
            },
          ),
        ),
      ],
    );
  }
  
  // ====================
  // MEDITATIONS SECTION
  // ====================
  
  Widget _buildMeditationsSection(SleepsController controller, AppTheme theme) {
    if (controller.meditationSleeps.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Meditations',
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.meditationSleeps.length,
            itemBuilder: (context, index) {
              final sleep = controller.meditationSleeps[index];
              return SleepCard(
                sleep: sleep,
                onTap: () => controller.onSleepTap(sleep),
              );
            },
          ),
        ),
      ],
    );
  }
  
  // ====================
  // LOADING VIEW
  // ====================
  
  Widget _buildLoadingView(AppTheme theme) {
    return Center(
      child: CircularProgressIndicator(
        color: theme.accentColor,
      ),
    );
  }
  
  // ====================
  // ERROR VIEW
  // ====================
  
  Widget _buildErrorView(SleepsController controller, AppTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: theme.textSecondary,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              controller.errorMessage,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: controller.loadAllSleeps,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.accentColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}