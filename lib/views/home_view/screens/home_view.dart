import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller/home_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../common_widgets/meditation_card.dart';

/// ====================
/// HOME VIEW
/// ====================
/// 
/// Main home screen with meditation cards
/// (Bottom nav is now in MainScaffold, not here)
class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme();
    
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // ✅ GOOD AFTERNOON HEADER (NO ICONS)
                _buildHeader(theme),
                
                // Content
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading) {
                      return _buildLoadingView(theme);
                    }
                    
                    if (controller.errorMessage.isNotEmpty) {
                      return _buildErrorView(theme);
                    }
                    
                    if (controller.meditations.isEmpty) {
                      return _buildEmptyView(theme);
                    }
                    
                    return _buildMeditationList(theme);
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // ====================
  // HEADER - GOOD AFTERNOON (WITHOUT ICONS)
  // ====================
  
  Widget _buildHeader(AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Obx(() => Text(
          controller.greeting,
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
  
  // ====================
  // MEDITATION LIST
  // ====================
  
  Widget _buildMeditationList(AppTheme theme) {
    return RefreshIndicator(
      onRefresh: controller.refreshMeditations,
      backgroundColor: theme.cardColor,
      color: theme.accentColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.meditations.length,
        itemBuilder: (context, index) {
          final meditation = controller.meditations[index];
          final isFirstCard = index == 0;
          
          return MeditationCard(
            meditation: meditation,
            isFirstCard: isFirstCard,
            onTap: () => controller.onMeditationTap(meditation),
            onStartCourseTap: () => controller.onStartCourseTap(meditation),
            onMoreTap: () => controller.onMoreTap(meditation),
          );
        },
      ),
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
  
  Widget _buildErrorView(AppTheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.textSecondary,
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
            controller.errorMessage,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          )),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.refreshMeditations,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.accentColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  // ====================
  // EMPTY VIEW
  // ====================
  
  Widget _buildEmptyView(AppTheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.self_improvement,
            size: 64,
            color: theme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No meditations available',
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}