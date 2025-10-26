import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common_widgets/course_card.dart';
import '../../../controllers/courses_controller/courses_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';

/// ====================
/// COURSES VIEW
/// ====================
/// 
/// Main screen for Courses tab

class CoursesView extends StatelessWidget {
  const CoursesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CoursesController>();
    final AppTheme theme = AppTheme();
    
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context, controller, theme),
                
                // Course List
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading) {
                      return _buildLoadingView(theme);
                    }
                    
                    if (controller.errorMessage.isNotEmpty) {
                      return _buildErrorView(controller, theme);
                    }
                    
                    return _buildCoursesList(controller, theme);
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // ====================
  // HEADER (WITHOUT ICONS)
  // ====================
  
  Widget _buildHeader(BuildContext context, CoursesController controller, AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Courses',
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
  // COURSES LIST
  // ====================
  
  Widget _buildCoursesList(CoursesController controller, AppTheme theme) {
    return RefreshIndicator(
      onRefresh: controller.refreshCourses,
      color: theme.accentColor,
      backgroundColor: theme.cardColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.courses.length,
        itemBuilder: (context, index) {
          final course = controller.courses[index];
          return CourseCard(
            course: course,
            onTap: () => controller.onCourseTap(course),
          );
        },
      ),
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
  
  Widget _buildErrorView(CoursesController controller, AppTheme theme) {
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
              onPressed: controller.loadCourses,
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