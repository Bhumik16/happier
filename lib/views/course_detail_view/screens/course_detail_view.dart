import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/course_detail_controller/course_detail_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/course_session_model.dart';
import '../../../core/utils/navigation_helper.dart';

/// ====================
/// COURSE DETAIL VIEW
/// ====================
/// 
/// Shows course overview, teacher info, and sessions list

class CourseDetailView extends StatelessWidget {
  const CourseDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseDetailController>();
    final AppTheme theme = AppTheme();
    
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Obx(() {
            if (controller.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.accentColor,
                ),
              );
            }

            if (controller.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: theme.buttonDangerText,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.loadCourse,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.buttonPrimary,
                      ),
                      child: Text(
                        'Retry',
                        style: TextStyle(color: theme.buttonTextColor),
                      ),
                    ),
                  ],
                ),
              );
            }

            final course = controller.course;
            if (course == null) {
              return Center(
                child: Text(
                  'Course not found',
                  style: TextStyle(color: theme.textPrimary),
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                // ====================
                // SLIVER APP BAR WITH COURSE IMAGE
                // ====================
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: theme.appBarColor,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.iconPrimary),
                    onPressed: () => NavigationHelper.goBackSimple(),
                  ),
                  actions: [
                    // ✅ HEART BUTTON (FAVORITE ENTIRE COURSE)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: Icon(
                            controller.isCourseFavorite ? Icons.favorite : Icons.favorite_border,
                            color: controller.isCourseFavorite ? Colors.red : Colors.white,
                          ),
                          onPressed: controller.toggleCourseFavorite,
                        ),
                      ),
                    ),
                    
                    // ✅ DOWNLOAD BUTTON - WITH STATUS
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: _buildDownloadButton(controller),
                      ),
                    ),
                    
                    // SHARE BUTTON
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {
                            Get.snackbar('Share', 'Share feature coming soon!');
                          },
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: course.hasImage && course.imageUrl != null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                course.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                              // ✅ UPDATED GRADIENT - Prevents cream color from overpowering image
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.white.withOpacity(0.3),
                                      theme.backgroundColor,
                                    ],
                                    stops: const [0.0, 0.4, 0.75, 1.0],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: course.gradientColors.isNotEmpty
                                    ? course.gradientColors
                                        .map((c) => Color(int.parse(c.substring(1, 7), radix: 16) + 0xFF000000))
                                        .toList()
                                    : [theme.accentColor, theme.cardColor],
                              ),
                            ),
                          ),
                  ),
                ),

                // ====================
                // COURSE INFO
                // ====================
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              course.instructor,
                              style: TextStyle(
                                color: theme.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                            if (course.totalSessions > 0) ...[
                              const SizedBox(width: 8),
                              Text('•', style: TextStyle(color: theme.textSecondary)),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              '${course.totalSessions} Sessions',
                              style: TextStyle(
                                color: theme.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        if (course.description != null && course.description!.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            course.description!,
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // ====================
                // TEACHER SECTION
                // ====================
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Teacher',
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
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
                              // Teacher avatar/icon
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF9B7C),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.self_improvement,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Teacher info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Happier Meditation',
                                      style: TextStyle(
                                        color: theme.textPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Award-winning meditation nerds',
                                      style: TextStyle(
                                        color: theme.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ====================
                // SESSIONS HEADER (WITH DOWNLOAD COUNT)
                // ====================
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sessions',
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // ✅ NEW: Show download count while downloading
                        Obx(() {
                          if (controller.isDownloading) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.accentColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Downloading: ${controller.currentDownloadIndex} of ${controller.totalSessionsToDownload}',
                                  style: TextStyle(
                                    color: theme.accentColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          } else if (controller.sessions.isNotEmpty) {
                            return Text(
                              '${controller.sessions.length} sessions',
                              style: TextStyle(
                                color: theme.textSecondary,
                                fontSize: 14,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                ),

                // ====================
                // SESSIONS LIST
                // ====================
                if (controller.isLoadingSessions)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          color: theme.accentColor,
                        ),
                      ),
                    ),
                  )
                else if (controller.sessions.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text(
                          'No sessions available',
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final session = controller.sessions[index];
                          return _buildSessionCard(session, controller, theme);
                        },
                        childCount: controller.sessions.length,
                      ),
                    ),
                  ),

                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  // ====================
  // ✅ DOWNLOAD BUTTON WITH STATUS
  // ====================
  Widget _buildDownloadButton(CourseDetailController controller) {
    if (controller.isDownloading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
    }
    
    if (controller.isCourseDownloaded) {
      return PopupMenuButton<String>(
        icon: const Icon(Icons.download_done, color: Colors.green),
        onSelected: (value) {
          if (value == 'delete') {
            controller.deleteCourseDownload();
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete Download'),
              ],
            ),
          ),
        ],
      );
    }
    
    return IconButton(
      icon: const Icon(Icons.download, color: Colors.white),
      onPressed: controller.downloadCourse,
    );
  }

  // ====================
  // SESSION CARD
  // ====================
  Widget _buildSessionCard(
    CourseSessionModel session,
    CourseDetailController controller,
    AppTheme theme,
  ) {
    return GestureDetector(
      onTap: () => controller.onSessionTap(session),
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
            // Session number badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: session.isCompleted
                    ? theme.accentColor.withOpacity(0.2)
                    : theme.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: session.isCompleted
                    ? Icon(Icons.check, color: theme.accentColor)
                    : Text(
                        '${session.sessionNumber}',
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),

            // Session info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (session.instructor.isNotEmpty) ...[
                        Text(
                          session.instructor,
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
                        '${session.durationMinutes} min',
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

            // HEART ICON
            Obx(() => IconButton(
              icon: Icon(
                controller.isSessionFavorite(session.id) ? Icons.favorite : Icons.favorite_border,
                color: controller.isSessionFavorite(session.id) ? Colors.red : theme.textSecondary,
                size: 24,
              ),
              onPressed: () => controller.toggleSessionFavorite(session),
            )),

            const SizedBox(width: 8),

            // Lock icon or play icon
            Icon(
              session.isLocked ? Icons.lock : Icons.play_circle_outline,
              color: session.isLocked
                  ? theme.textSecondary
                  : theme.accentColor,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}