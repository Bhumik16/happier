import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/favorites_list_controller/favorites_list_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/navigation_helper.dart';

/// ====================
/// FAVORITES LIST VIEW
/// ====================
/// Shows favorites or recently played sessions

class FavoritesListView extends StatelessWidget {
  const FavoritesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesListController>();
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
              onPressed: () => NavigationHelper.goBackSimple(),
            ),
            title: Obx(() => Text(
              controller.isShowingFavorites ? 'Your Favorites' : 'Recently Played',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )),
            actions: [
              Obx(() {
                if (controller.items.isEmpty) return const SizedBox.shrink();
                
                return IconButton(
                  icon: Icon(Icons.delete_outline, color: theme.iconPrimary),
                  onPressed: () => _showClearDialog(context, controller, theme),
                );
              }),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: theme.accentColor),
              );
            }
            
            if (controller.items.isEmpty) {
              return _buildEmptyState(controller, theme);
            }
            
            return RefreshIndicator(
              onRefresh: controller.refresh,
              color: theme.accentColor,
              backgroundColor: theme.cardColor,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return _buildSessionCard(item, controller, index, theme);
                },
              ),
            );
          }),
        );
      },
    );
  }
  
  // ====================
  // SESSION CARD
  // ====================
  
  Widget _buildSessionCard(
    Map<String, dynamic> item,
    FavoritesListController controller,
    int index,
    AppTheme theme,
  ) {
    final title = item['title'] ?? 'Unknown Session';
    final instructor = item['instructor'] ?? 'Unknown';
    final duration = item['durationMinutes'] ?? 0;
    final sessionId = item['sessionId'] ?? '';
    
    return Dismissible(
      key: Key('${sessionId}_$index'),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        controller.removeItem(index);
      },
      child: GestureDetector(
        onTap: () => controller.playSession(item),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.borderColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Play icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: theme.accentColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Session info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (instructor.isNotEmpty) ...[
                          Text(
                            instructor,
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('•', style: TextStyle(color: theme.textSecondary)),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '$duration min',
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Favorite icon (only for favorites view)
              if (controller.isShowingFavorites)
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  // ====================
  // EMPTY STATE
  // ====================
  
  Widget _buildEmptyState(FavoritesListController controller, AppTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              controller.isShowingFavorites ? Icons.favorite_border : Icons.history,
              size: 80,
              color: theme.textSecondary,
            ),
            const SizedBox(height: 20),
            Text(
              controller.isShowingFavorites 
                  ? 'No Favorites Yet' 
                  : 'No History Yet',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              controller.isShowingFavorites
                  ? 'Tap the heart icon in the player to save your favorite sessions'
                  : 'Your recently played sessions will appear here',
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  // ====================
  // CLEAR DIALOG
  // ====================
  
  void _showClearDialog(
    BuildContext context,
    FavoritesListController controller,
    AppTheme theme,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: theme.dialogBackground,
        title: Text(
          controller.isShowingFavorites ? 'Clear Favorites?' : 'Clear History?',
          style: TextStyle(
            color: theme.dialogTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          controller.isShowingFavorites
              ? 'This will remove all your favorite sessions.'
              : 'This will clear your recently played history.',
          style: TextStyle(
            color: theme.textSecondary,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: theme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearAll();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}