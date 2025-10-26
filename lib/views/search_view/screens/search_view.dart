import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/search_controller/search_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/navigation_helper.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchViewController>();
    final AppTheme theme = AppTheme();

    if (!Get.isRegistered<AppearanceController>()) {
      Get.put(AppearanceController());
    }

    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and Search Bar
                _buildTopBar(controller, theme, context),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Teachers Section
                        _buildTeachersSection(controller, theme),

                        const SizedBox(height: 40),

                        // Suggested Topics Section
                        _buildSuggestedSection(controller, theme),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(SearchViewController controller, AppTheme theme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(Icons.arrow_back, color: theme.iconPrimary, size: 28),
            onPressed: () => NavigationHelper.goBackSimple(),
          ),
          const SizedBox(width: 8),
          // Search bar
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: theme.borderColor, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: theme.textSecondary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.onSearchChanged,
                      autofocus: true, // ✅ Keyboard shows automatically
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeachersSection(SearchViewController controller, AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Teachers',
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.teachers.length,
            itemBuilder: (context, index) {
              final teacher = controller.teachers[index];
              return _buildTeacherCard(teacher, theme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTeacherCard(Map<String, String> teacher, AppTheme theme) {
    return GestureDetector(
      onTap: () {
        Get.snackbar(
          'Teacher',
          'Opening ${teacher['name']} profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: theme.cardColor,
          colorText: theme.textPrimary,
        );
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            // Profile Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.accentColor.withOpacity(0.2),
                border: Border.all(
                  color: theme.accentColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: theme.accentColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Teacher Name
            Text(
              teacher['name']!,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedSection(SearchViewController controller, AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Suggested',
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.suggestedTopics.length,
          itemBuilder: (context, index) {
            final topic = controller.suggestedTopics[index];
            return _buildTopicItem(topic, theme);
          },
        ),
      ],
    );
  }

  Widget _buildTopicItem(String topic, AppTheme theme) {
    return InkWell(
      onTap: () {
        Get.snackbar(
          'Topic',
          'Opening $topic meditations',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: theme.cardColor,
          colorText: theme.textPrimary,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              topic,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.textSecondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}