import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/recommended_courses_controller/recommended_courses_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';

class RecommendedCoursesView extends StatelessWidget {
  const RecommendedCoursesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecommendedCoursesController>();
    final AppTheme theme = AppTheme();

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: theme.iconPrimary),
        title: Text(
          controller.topicName,
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: theme.accentColor),
          );
        }

        if (controller.totalRecommendations == 0) {
          return _buildEmptyState(theme);
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Results count
                Text(
                  '${controller.totalRecommendations} ${controller.totalRecommendations == 1 ? 'result' : 'results'} found',
                  style: TextStyle(color: theme.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Courses Section
                if (controller.recommendedCourses.isNotEmpty) ...[
                  Text(
                    'Courses',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...controller.recommendedCourses.map((course) {
                    return _buildCourseCard(course, theme);
                  }).toList(),
                ],

                // Sleeps Section
                if (controller.recommendedSleeps.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Text(
                    'Sleep Meditations',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...controller.recommendedSleeps.map((sleep) {
                    return _buildSleepCard(sleep, theme);
                  }).toList(),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(AppTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: theme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No recommendations found',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try exploring other topics',
              style: TextStyle(color: theme.textSecondary, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(dynamic course, AppTheme theme) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.courseDetail, arguments: course.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.borderColor),
        ),
        child: Row(
          children: [
            // Course Image/Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: course.gradientColors.isNotEmpty
                      ? course.gradientColors
                            .map<Color>((c) => Color(int.parse(c)))
                            .toList()
                      : [
                          theme.accentColor.withValues(alpha: 0.3),
                          theme.accentColor,
                        ],
                ),
              ),
              child: course.hasImage && course.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        course.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 40,
                          );
                        },
                      ),
                    )
                  : Icon(Icons.school, color: Colors.white, size: 40),
            ),
            const SizedBox(width: 16),
            // Course Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.instructor,
                    style: TextStyle(color: theme.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        color: theme.accentColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.totalSessions} sessions',
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time,
                        color: theme.accentColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.durationMinutes} min',
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.textSecondary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepCard(dynamic sleep, AppTheme theme) {
    return GestureDetector(
      onTap: () {
        // Navigate directly to sleep audio player with the sleep object
        Get.toNamed(
          AppRoutes.sleepAudioPlayer,
          arguments: {
            'sleep': sleep,
            'duration': 15, // Default duration
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.borderColor),
        ),
        child: Row(
          children: [
            // Sleep Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.accentColor.withValues(alpha: 0.2),
              ),
              child: Icon(Icons.bedtime, color: theme.accentColor, size: 30),
            ),
            const SizedBox(width: 16),
            // Sleep Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sleep.title,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sleep.instructor,
                    style: TextStyle(color: theme.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: theme.accentColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        sleep.durationRange,
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.textSecondary, size: 24),
          ],
        ),
      ),
    );
  }
}
