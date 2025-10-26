import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common_widgets/practice_video_card.dart';
import '../../../common_widgets/singles_card.dart';
import '../../../common_widgets/podcast_card.dart';
import '../../../controllers/shorts_controller/shorts_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/single_model.dart';

/// ====================
/// SHORTS VIEW
/// ====================
/// 
/// Main screen for Shorts tab with 3 sections

class ShortsView extends StatelessWidget {
  const ShortsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShortsController>();
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
                onRefresh: controller.refreshShorts,
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
                      
                      // Practice In Action Section
                      _buildPracticeSection(controller, theme),
                      
                      const SizedBox(height: 30),
                      
                      // Wisdom Clips Section
                      _buildWisdomSection(controller, theme),
                      
                      const SizedBox(height: 30),
                      
                      // Podcasts Section
                      _buildPodcastsSection(controller, theme),
                      
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
  
  Widget _buildHeader(BuildContext context, ShortsController controller, AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Shorts',
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
  // PRACTICE IN ACTION SECTION
  // ====================
  
  Widget _buildPracticeSection(ShortsController controller, AppTheme theme) {
    if (controller.practiceShorts.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Practice In Action',
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: controller.practiceShorts.length,
            itemBuilder: (context, index) {
              final practice = controller.practiceShorts[index];
              return PracticeVideoCard(
                practice: practice,
                onTap: () => controller.onShortTap(practice),
              );
            },
          ),
        ),
      ],
    );
  }
  
  // ====================
  // WISDOM CLIPS SECTION (2x2 Grid)
  // ====================
  
  Widget _buildWisdomSection(ShortsController controller, AppTheme theme) {
    if (controller.wisdomShorts.isEmpty) return const SizedBox.shrink();
    
    // Show only first 8 items initially for 2x2 scrollable grid
    final displayItems = controller.wisdomShorts.take(8).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Wisdom Clips',
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 420,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: (displayItems.length / 2).ceil(),
            itemBuilder: (context, columnIndex) {
              final startIndex = columnIndex * 2;
              final endIndex = (startIndex + 2).clamp(0, displayItems.length);
              final columnItems = displayItems.sublist(startIndex, endIndex);
              
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: columnItems.map((wisdom) {
                    // Convert ShortModel to SingleModel for SingleCard
                    final singleModel = SingleModel(
                      id: wisdom.id,
                      title: wisdom.title,
                      gradientColors: wisdom.gradientColors,
                      category: 'wisdom',
                    );
                    
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SingleCard(
                          single: singleModel,
                          onTap: () => controller.onShortTap(wisdom),
                          height: 200,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  // ====================
  // PODCASTS SECTION
  // ====================
  
  Widget _buildPodcastsSection(ShortsController controller, AppTheme theme) {
    if (controller.podcastShorts.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Podcasts',
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: controller.podcastShorts.length,
            itemBuilder: (context, index) {
              final podcast = controller.podcastShorts[index];
              return PodcastCard(
                podcast: podcast,
                onTap: () => controller.onShortTap(podcast),
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
  
  Widget _buildErrorView(ShortsController controller, AppTheme theme) {
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
              onPressed: controller.loadAllShorts,
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