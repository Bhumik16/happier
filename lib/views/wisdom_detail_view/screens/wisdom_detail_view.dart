import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/wisdom_detail_controller/wisdom_detail_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/navigation_helper.dart';

/// ====================
/// WISDOM DETAIL VIEW
/// ====================
/// 
/// Shows list of wisdom clip sessions

class WisdomDetailView extends GetView<WisdomDetailController> {
  const WisdomDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme();
    
    return Scaffold(
      body: Container(
        // ✅ Gradient stays the same - colorful gradients look great in both themes
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: controller.gradientColors.isEmpty
                ? [const Color(0xFF4DD0E1), const Color(0xFF5C6BC0)]
                : controller.gradientColors.map((hex) {
                    return Color(int.parse(hex.replaceFirst('#', '0xff')));
                  }).toList(),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              _buildTopBar(),

              // Hero Section
              Expanded(
                flex: 2,
                child: _buildHeroSection(),
              ),

              // Sessions List
              Expanded(
                flex: 3,
                child: _buildSessionsList(theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====================
  // TOP BAR
  // ====================

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          IconButton(
            onPressed: () => NavigationHelper.goBackSimple(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            ),
          ),

          // Cast Button
          IconButton(
            onPressed: () {
              Get.snackbar(
                'Cast',
                'Coming soon',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(
              Icons.cast,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  // ====================
  // HERO SECTION
  // ====================

  Widget _buildHeroSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // "WISDOM CLIPS" Label
          const Text(
            'WISDOM CLIPS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Collection Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              controller.collectionTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w300,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          // Decorative Line
          Container(
            width: 60,
            height: 2,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  // ====================
  // SESSIONS LIST
  // ====================

  Widget _buildSessionsList(AppTheme theme) {
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: Obx(() {
            if (controller.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: theme.accentColor),
              );
            }

            if (controller.sessions.isEmpty) {
              return Center(
                child: Text(
                  'No sessions available',
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 16,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              itemCount: controller.sessions.length,
              itemBuilder: (context, index) {
                final session = controller.sessions[index];
                return _buildSessionItem(session, theme);
              },
            );
          }),
        );
      },
    );
  }

  // ====================
  // SESSION ITEM
  // ====================

  Widget _buildSessionItem(dynamic session, AppTheme theme) {
    return InkWell(
      onTap: () => controller.onSessionTap(session),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Instructor Photo
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(28),
                image: session.instructor != null
                    ? const DecorationImage(
                        image: AssetImage('assets/images/instructor_placeholder.jpg'),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: session.instructor == null
                  ? Icon(Icons.person, color: theme.textSecondary)
                  : null,
            ),

            const SizedBox(width: 16),

            // Title and Duration
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session.duration ?? '30 sec',
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
    );
  }
}