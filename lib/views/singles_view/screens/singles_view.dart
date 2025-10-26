import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common_widgets/singles_card.dart';
import '../../../controllers/singles_controller/singles_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';

/// ====================
/// SINGLES VIEW
/// ====================
/// 
/// Main screen for Singles tab

class SinglesView extends StatelessWidget {
  const SinglesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SinglesController>();
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
                onRefresh: controller.refreshSingles,
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
                      
                      // For You Section
                      _buildForYouSection(controller, theme),
                      
                      const SizedBox(height: 30),
                      
                      // Featured Section
                      _buildFeaturedSection(controller, theme),
                      
                      const SizedBox(height: 30),
                      
                      // Browse All Section
                      _buildBrowseAllSection(controller, theme),
                      
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
  
  Widget _buildHeader(BuildContext context, SinglesController controller, AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Singles',
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
  // FOR YOU SECTION
  // ====================
  
  Widget _buildForYouSection(SinglesController controller, AppTheme theme) {
    if (controller.forYouSingles.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'For You',
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
          child: Row(
            children: [
              // Favorites
              Expanded(
                child: SingleCard(
                  single: controller.forYouSingles[0],
                  onTap: () => controller.onSingleTap(controller.forYouSingles[0]),
                  height: 200,
                ),
              ),
              const SizedBox(width: 12),
              // Recently Played
              Expanded(
                child: SingleCard(
                  single: controller.forYouSingles[1],
                  onTap: () => controller.onSingleTap(controller.forYouSingles[1]),
                  height: 200,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // ====================
  // FEATURED SECTION
  // ====================
  
  Widget _buildFeaturedSection(SinglesController controller, AppTheme theme) {
    if (controller.featuredSingles.isEmpty) return const SizedBox.shrink();
    
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
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: controller.featuredSingles.length,
            itemBuilder: (context, index) {
              final single = controller.featuredSingles[index];
              return SingleCard(
                single: single,
                onTap: () => controller.onSingleTap(single),
                height: 200,
              );
            },
          ),
        ),
      ],
    );
  }
  
  // ====================
  // BROWSE ALL SECTION
  // ====================
  
  Widget _buildBrowseAllSection(SinglesController controller, AppTheme theme) {
    if (controller.browseAllSingles.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Browse All',
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
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: controller.browseAllSingles.length,
            itemBuilder: (context, index) {
              final single = controller.browseAllSingles[index];
              return SingleCard(
                single: single,
                onTap: () => controller.onSingleTap(single),
                height: 200,
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
  
  Widget _buildErrorView(SinglesController controller, AppTheme theme) {
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
              onPressed: controller.loadAllSingles,
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