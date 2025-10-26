import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_theme.dart';
import '../controllers/appearance_controller/appearance_controller.dart';
import '../data/models/sleep_model.dart';

/// ====================
/// SLEEP CARD
/// ====================
/// 
/// List item card for sleep meditations with instructor photo

class SleepCard extends StatelessWidget {
  final SleepModel sleep;
  final VoidCallback onTap;
  final AppTheme _theme = AppTheme();
  
  SleepCard({
    Key? key,
    required this.sleep,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppearanceController>(
      builder: (controller) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _theme.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Instructor Photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: _theme.cardColor,
                    child: Image.asset(
                      sleep.instructorImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to icon if image not found
                        return Icon(
                          Icons.person,
                          size: 40,
                          color: _theme.textSecondary,
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        sleep.title,
                        style: TextStyle(
                          color: _theme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Duration and Instructor
                      Text(
                        '${sleep.durationRange} • ${sleep.instructor}',
                        style: TextStyle(
                          color: _theme.textSecondary,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Lock icon placeholder (removed as everything is free)
                // Just add spacing
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}