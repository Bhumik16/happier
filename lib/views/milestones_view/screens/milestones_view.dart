import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/milestones_controller/milestones_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/utils/navigation_helper.dart'; // ✅ ADDED
import '../widgets/milestone_badge_painter.dart';

/// ====================
/// MILESTONES VIEW
/// ====================

class MilestonesView extends StatelessWidget {
  const MilestonesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MilestonesController());
    
    // Ensure AppearanceController is initialized
    if (!Get.isRegistered<AppearanceController>()) {
      Get.put(AppearanceController());
    }
    
    final AppTheme theme = AppTheme();
    
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
            backgroundColor: theme.appBarColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.iconPrimary),
              onPressed: () => NavigationHelper.goBackSimple(), // ✅ FIXED
            ),
            title: Text(
              'Milestones',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: theme.textPrimary,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DAILY STREAKS
                _buildSectionTitle('Daily Streaks', theme),
                const SizedBox(height: 20),
                _buildDailyStreaks(controller, theme),
                
                const SizedBox(height: 40),
                
                // WEEKLY STREAKS
                _buildSectionTitle('Weekly Streaks', theme),
                const SizedBox(height: 20),
                _buildWeeklyStreaks(controller, theme),
                
                const SizedBox(height: 40),
                
                // MY JOURNEY
                _buildSectionTitle('My Journey', theme),
                const SizedBox(height: 20),
                _buildMyJourney(controller, theme),
                
                const SizedBox(height: 40),
                
                // FIRSTS
                _buildSectionTitle('Firsts', theme),
                const SizedBox(height: 20),
                _buildFirsts(controller, theme),
                
                const SizedBox(height: 40),
                
                // ENGAGEMENT
                _buildSectionTitle('Engagement', theme),
                const SizedBox(height: 20),
                _buildEngagement(controller, theme),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildSectionTitle(String title, AppTheme theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: theme.textPrimary,
      ),
    );
  }
  
  /// DAILY STREAKS - Hexagons
  Widget _buildDailyStreaks(MilestonesController controller, AppTheme theme) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.dailyStreakMilestones.length,
        itemBuilder: (context, index) {
          final days = controller.dailyStreakMilestones[index];
          final isAchieved = controller.isDailyStreakAchieved(days);
          
          return _buildBadgeItem(
            painter: HexagonBadgePainter(
              text: days.toString(),
              isCompleted: isAchieved,
              textColor: theme.textPrimary,
            ),
            label: '$days Day Streak',
            count: isAchieved ? days : 0,
            theme: theme,
          );
        },
      ),
    );
  }
  
  /// WEEKLY STREAKS - Circles
  Widget _buildWeeklyStreaks(MilestonesController controller, AppTheme theme) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.weeklyStreakMilestones.length,
        itemBuilder: (context, index) {
          final weeks = controller.weeklyStreakMilestones[index];
          final isAchieved = controller.isWeeklyStreakAchieved(weeks);
          
          return _buildBadgeItem(
            painter: CircleBadgePainter(
              text: weeks.toString(),
              isCompleted: isAchieved,
              textColor: theme.textPrimary,
            ),
            label: '$weeks Week Streak',
            count: isAchieved ? weeks : 0,
            theme: theme,
          );
        },
      ),
    );
  }
  
  /// MY JOURNEY - Shields (without count badge)
  Widget _buildMyJourney(MilestonesController controller, AppTheme theme) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.journeyMilestones.length,
        itemBuilder: (context, index) {
          final milestone = controller.journeyMilestones[index];
          final isAchieved = controller.isJourneyAchieved(milestone);
          final displayText = milestone == 'First' ? '1' : milestone.toString();
          final label = milestone == 'First' 
              ? 'First Session' 
              : '$milestone Sessions';
          
          // Gradient for first session (achieved)
          List<Color>? gradientColors;
          if (isAchieved && milestone == 'First') {
            gradientColors = [
              const Color(0xFF7CB342), // Green
              const Color(0xFFD4AF37), // Gold
              const Color(0xFFB8956A), // Tan
            ];
          }
          
          return _buildJourneyBadgeItem(
            painter: ShieldBadgePainter(
              text: displayText,
              isCompleted: isAchieved,
              gradientColors: gradientColors,
              textColor: theme.textPrimary,
            ),
            label: label,
            theme: theme,
          );
        },
      ),
    );
  }
  
  /// FIRSTS SECTION - Horizontal Scroll
  Widget _buildFirsts(MilestonesController controller, AppTheme theme) {
    final firstsItems = [
      // First Course Session - Star (with gradient)
      _buildIconBadge(
        painter: StarBadgePainter(
          isCompleted: controller.hasCompletedFirstCourseSession.value,
          gradientColors: controller.hasCompletedFirstCourseSession.value
              ? [const Color(0xFF4DB8C4), const Color(0xFF9C27B0)]
              : null,
        ),
        label: 'First Course Session',
        isCompleted: controller.hasCompletedFirstCourseSession.value,
        theme: theme,
      ),
      
      _buildIconBadge(
        icon: Icons.self_improvement,
        label: 'First Single',
        isCompleted: false,
        theme: theme,
      ),
      
      _buildIconBadge(
        icon: Icons.lightbulb_outline,
        label: 'First Talk',
        isCompleted: false,
        theme: theme,
      ),
      
      _buildIconBadge(
        painter: CrescentMoonPainter(isCompleted: false),
        label: 'First Sleep',
        isCompleted: false,
        theme: theme,
      ),
      
      _buildIconBadge(
        icon: Icons.timer_outlined,
        label: 'First Unguided Timer',
        isCompleted: false,
        theme: theme,
      ),
      
      _buildIconBadge(
        icon: Icons.menu_book_outlined,
        label: 'The Basics',
        isCompleted: false,
        theme: theme,
      ),
    ];
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: firstsItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: firstsItems[index],
          );
        },
      ),
    );
  }
  
  /// ENGAGEMENT SECTION - Horizontal Scroll
  Widget _buildEngagement(MilestonesController controller, AppTheme theme) {
    final engagementItems = [
      // Shared Guest Pass - Gift box (with gradient)
      _buildIconBadge(
        painter: GiftBoxPainter(
          isCompleted: controller.hasSharedGuestPass.value,
          gradientColors: controller.hasSharedGuestPass.value
              ? [const Color(0xFF4DB8C4), const Color(0xFF64B5F6)]
              : null,
        ),
        label: 'Shared Guest Pass',
        isCompleted: controller.hasSharedGuestPass.value,
        theme: theme,
      ),
      
      // Add a Favourite - Heart (with darker gradient)
      _buildIconBadge(
        painter: HeartPainter(
          isCompleted: controller.hasAddedFavorite.value,
          gradientColors: controller.hasAddedFavorite.value
              ? [
                  const Color(0xFFD81B60),
                  const Color(0xFFC2185B),
                  const Color(0xFFAD1457),
                ]
              : null,
        ),
        label: 'Add a Favorite',
        isCompleted: controller.hasAddedFavorite.value,
        theme: theme,
      ),
    ];
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: engagementItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: engagementItems[index],
          );
        },
      ),
    );
  }
  
  /// Generic badge item with painter, label, and count
  Widget _buildBadgeItem({
    required CustomPainter painter,
    required String label,
    required int count,
    required AppTheme theme,
  }) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: CustomPaint(
              painter: painter,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: theme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: theme.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 14,
                color: theme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Journey badge item (without count badge)
  Widget _buildJourneyBadgeItem({
    required CustomPainter painter,
    required String label,
    required AppTheme theme,
  }) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: CustomPaint(
              painter: painter,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: theme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  /// Icon badge with simple icons or custom painter
  Widget _buildIconBadge({
    CustomPainter? painter,
    IconData? icon,
    required String label,
    required bool isCompleted,
    required AppTheme theme,
  }) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: painter != null
                ? CustomPaint(painter: painter)
                : Icon(
                    icon,
                    size: 60,
                    color: theme.textSecondary.withOpacity(0.5),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: theme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}