import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_theme.dart';
import '../controllers/appearance_controller/appearance_controller.dart';
import '../data/models/short_model.dart';

/// ====================
/// PRACTICE VIDEO CARD
/// ====================
///
/// Video thumbnail card with play button overlay

class PracticeVideoCard extends StatelessWidget {
  final ShortModel practice;
  final VoidCallback onTap;
  final AppTheme _theme = AppTheme();

  PracticeVideoCard({Key? key, required this.practice, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppearanceController>(
      builder: (controller) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 280,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _theme.cardColor,
              boxShadow: [_theme.cardShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Thumbnail with Play Button
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        color: _theme.cardColor,
                        child: practice.thumbnailImage != null
                            ? Image.asset(
                                practice.thumbnailImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.video_library,
                                    size: 60,
                                    color: _theme.textSecondary,
                                  );
                                },
                              )
                            : Icon(
                                Icons.video_library,
                                size: 60,
                                color: _theme.textSecondary,
                              ),
                      ),
                    ),

                    // Play Button Overlay
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        practice.title,
                        style: TextStyle(
                          color: _theme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        practice.duration ?? '',
                        style: TextStyle(
                          color: _theme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
