import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/downloads_controller/downloads_controller.dart';
import '../../../core/services/downloads_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/utils/navigation_helper.dart'; // ✅ ADDED

class DownloadsView extends GetView<DownloadsController> {
  const DownloadsView({super.key});

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
              'Downloads',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Obx(() {
                if (controller.downloadedItems.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: TextButton.icon(
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          backgroundColor: theme.dialogBackground,
                          title: Text(
                            'Clear All Downloads',
                            style: TextStyle(color: theme.textPrimary),
                          ),
                          content: Text(
                            'Are you sure you want to delete all downloaded content? This will free up ${controller.totalStorage.value}.',
                            style: TextStyle(color: theme.textSecondary),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.clearAllDownloads();
                                Get.back();
                              },
                              child: const Text(
                                'Clear All',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: Colors.red,
                      size: 18,
                    ),
                    label: const Text(
                      'Clear All',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: theme.accentColor),
              );
            }

            if (controller.downloadedItems.isEmpty) {
              return _buildEmptyState(theme);
            }

            return _buildDownloadsList(theme);
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
              Icons.cloud_download,
              size: 80,
              color: theme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 30),
            Text(
              "Sometimes it's good to unplug. Here's where all your offline courses, meditations, and podcast episodes live.",
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

  Widget _buildDownloadsList(AppTheme theme) {
    // Separate downloads by type
    final courses = controller.downloadedItems
        .where((e) => e.value['type'] == 'course_session')
        .toList();
    final sleeps = controller.downloadedItems
        .where((e) => e.value['type'] == 'sleep')
        .toList();
    final podcasts = controller.downloadedItems
        .where((e) => e.value['type'] == 'podcast')
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Storage info card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.borderColor, width: 1),
            ),
            child: Obx(
              () => Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.storage,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Storage Used',
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.totalStorage.value,
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${controller.downloadedItems.length} ${controller.downloadedItems.length == 1 ? 'item' : 'items'}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SECTION 1: COURSES
          if (courses.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  const Icon(Icons.school, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Courses (${courses.length})',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ...courses.map(
              (entry) => _buildDownloadItem(entry.key, entry.value, theme),
            ),
            const SizedBox(height: 8),
          ],

          // SECTION 2: SLEEP AUDIOS
          if (sleeps.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.nightlight_round,
                    color: Colors.purple,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sleep Audios (${sleeps.length})',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ...sleeps.map(
              (entry) => _buildDownloadItem(entry.key, entry.value, theme),
            ),
            const SizedBox(height: 8),
          ],

          // SECTION 3: PODCAST EPISODES
          if (podcasts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  const Icon(Icons.mic, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Podcast Episodes (${podcasts.length})',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ...podcasts.map(
              (entry) => _buildDownloadItem(entry.key, entry.value, theme),
            ),
          ],

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildDownloadItem(
    String id,
    Map<String, dynamic> item,
    AppTheme theme,
  ) {
    final fileSize = item['fileSize'] as int?;
    final fileSizeText = fileSize != null
        ? Get.find<DownloadsService>().formatBytes(fileSize)
        : '';

    final downloadedAt = item['downloadedAt'] as String?;
    String dateText = '';
    if (downloadedAt != null) {
      try {
        final date = DateTime.parse(downloadedAt);
        final now = DateTime.now();
        final difference = now.difference(date);

        if (difference.inDays == 0) {
          dateText = 'Today';
        } else if (difference.inDays == 1) {
          dateText = 'Yesterday';
        } else if (difference.inDays < 7) {
          dateText = '${difference.inDays}d ago';
        } else {
          dateText = '${date.day}/${date.month}/${date.year}';
        }
      } catch (e) {
        dateText = '';
      }
    }

    // Get icon color based on type
    Color iconColor;
    if (item['type'] == 'course_session') {
      iconColor = Colors.blue;
    } else if (item['type'] == 'sleep') {
      iconColor = Colors.purple;
    } else if (item['type'] == 'podcast') {
      iconColor = Colors.orange;
    } else {
      iconColor = Colors.grey;
    }

    return Card(
      color: theme.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () {
          controller.playDownloadedItem(id, item);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            iconColor.withValues(alpha: 0.3),
                            iconColor.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: Icon(Icons.play_arrow, color: iconColor, size: 28),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.download_done,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      item['sessionTitle'] ?? item['title'] ?? 'Unknown',
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Course title
                    if (item['courseTitle'] != null)
                      Text(
                        item['courseTitle'],
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    const SizedBox(height: 6),

                    // Metadata row
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (item['type'] != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: iconColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item['type'].toString().toUpperCase().replaceAll(
                                '_',
                                ' ',
                              ),
                              style: TextStyle(
                                color: iconColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (fileSizeText.isNotEmpty)
                          Text(
                            fileSizeText,
                            style: TextStyle(
                              color: theme.textSecondary.withValues(alpha: 0.7),
                              fontSize: 10,
                            ),
                          ),
                        if (dateText.isNotEmpty)
                          Text(
                            dateText,
                            style: TextStyle(
                              color: theme.textSecondary.withValues(alpha: 0.7),
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Delete button
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      backgroundColor: theme.dialogBackground,
                      title: Text(
                        'Delete Download',
                        style: TextStyle(color: theme.textPrimary),
                      ),
                      content: Text(
                        'Are you sure you want to delete "${item['sessionTitle'] ?? item['title']}"?',
                        style: TextStyle(color: theme.textSecondary),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.deleteDownload(id);
                            Get.back();
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
