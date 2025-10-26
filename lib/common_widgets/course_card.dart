import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_theme.dart';
import '../controllers/appearance_controller/appearance_controller.dart';
import '../data/models/course_model.dart';

/// ====================
/// COURSE CARD
/// ====================
/// 
/// Reusable card component for course items on Courses tab

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;
  final AppTheme _theme = AppTheme();
  
  CourseCard({
    Key? key,
    required this.course,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppearanceController>(
      builder: (controller) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: 380,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                _theme.cardShadow,
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  _buildBackground(),
                  
                  // Gradient Overlay (dark for text readability - stays same in both themes)
                  _buildGradientOverlay(),
                  
                  // Content
                  _buildContent(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  // ====================
  // BACKGROUND
  // ====================
  
  Widget _buildBackground() {
    if (course.hasImage && course.imageUrl != null) {
      return Image.asset(
        course.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: _theme.cardColor,
          );
        },
      );
    } else {
      return Container(
        color: _theme.cardColor,
      );
    }
  }
  
  // ====================
  // GRADIENT OVERLAY
  // ====================
  
  Widget _buildGradientOverlay() {
    // ✅ Dark gradient stays the same for both themes
    // This ensures text is readable on the image
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
  
  // ====================
  // CONTENT
  // ====================
  
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          
          // Subtitle (if exists)
          if (course.subtitle != null) ...[
            Text(
              course.subtitle!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
          ],
          
          // Title
          Text(
            course.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 16),
          
          // Instructor
          Text(
            'Guided by ${course.instructor}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}