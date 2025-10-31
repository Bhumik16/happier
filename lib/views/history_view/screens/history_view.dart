import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/history_controller/history_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/utils/navigation_helper.dart'; // ✅ ADDED

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
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
              'History',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.cast, color: theme.iconPrimary),
                onPressed: () {
                  Get.snackbar('Cast', 'Cast feature coming soon!');
                },
              ),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: theme.accentColor),
              );
            }

            if (controller.historyItems.isEmpty) {
              return _buildEmptyState(theme);
            }

            return _buildHistoryList(theme);
          }),
        );
      },
    );
  }

  Widget _buildEmptyState(AppTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: theme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 30),
            Text(
              "See how far you've come. Your completed meditations, podcast episodes, and courses will show up here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(AppTheme theme) {
    return Obx(() {
      final grouped = controller.groupedHistory;
      final monthYears = grouped.keys.toList();

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: monthYears.length,
        itemBuilder: (context, index) {
          final monthYear = monthYears[index];
          final items = grouped[monthYear]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month/Year Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Text(
                  monthYear,
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              // Items for this month
              ...items.map((item) => _buildHistoryItem(item, theme)).toList(),

              const SizedBox(height: 8),
            ],
          );
        },
      );
    });
  }

  Widget _buildHistoryItem(Map<String, dynamic> item, AppTheme theme) {
    final itemId = item['id'] as String;
    final title = item['title'] ?? 'Unknown';
    final subtitle = item['courseTitle'] ?? item['subtitle'] ?? 'Get Started';
    final thumbnailUrl = item['thumbnailUrl'] as String?;

    return Obx(() {
      final isFavorite = controller.favoriteStatus[itemId] ?? false;

      return InkWell(
        onTap: () => controller.playHistoryItem(item),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.dividerColor, width: 1),
            ),
          ),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: theme.cardColor,
                  child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                      ? Image.network(
                          thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.play_circle_outline,
                            color: theme.iconPrimary,
                            size: 40,
                          ),
                        )
                      : Icon(
                          Icons.play_circle_outline,
                          color: theme.iconPrimary,
                          size: 40,
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Favorite Icon
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? theme.accentColor : theme.textSecondary,
                  size: 28,
                ),
                onPressed: () => controller.toggleFavorite(itemId),
              ),
            ],
          ),
        ),
      );
    });
  }
}
