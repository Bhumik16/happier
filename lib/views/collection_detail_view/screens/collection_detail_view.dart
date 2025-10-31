import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/collection_detail_controller/collection_detail_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/navigation_helper.dart';

/// ====================
/// COLLECTION DETAIL VIEW
/// ====================
///
/// Shows collection info with gradient hero + featured sessions list

class CollectionDetailView extends StatelessWidget {
  const CollectionDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CollectionDetailController>();
    final AppTheme theme = AppTheme();

    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Obx(() {
            if (controller.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: theme.accentColor),
              );
            }

            return CustomScrollView(
              slivers: [
                // ====================
                // GRADIENT HERO SECTION
                // ====================
                SliverToBoxAdapter(
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: controller.collection.gradientColors
                            .map(
                              (c) =>
                                  Color(int.parse(c.substring(2), radix: 16)),
                            )
                            .toList(),
                      ),
                    ),
                    child: SafeArea(
                      child: Stack(
                        children: [
                          // Back button
                          Positioned(
                            top: 8,
                            left: 8,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () => NavigationHelper.goBackSimple(),
                            ),
                          ),

                          // Share button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () {
                                Get.snackbar(
                                  'Share',
                                  'Share feature coming soon!',
                                );
                              },
                            ),
                          ),

                          // Cast button
                          Positioned(
                            top: 8,
                            right: 56,
                            child: IconButton(
                              icon: const Icon(
                                Icons.cast,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () {
                                Get.snackbar(
                                  'Cast',
                                  'Cast feature coming soon!',
                                );
                              },
                            ),
                          ),

                          // Collection title and description
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'COLLECTION',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    controller.collection.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (controller.collection.description !=
                                      null) ...[
                                    const SizedBox(height: 20),
                                    // Decorative line
                                    Container(
                                      width: 60,
                                      height: 2,
                                      color: Colors.white54,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      controller.collection.description!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ====================
                // FEATURED SESSIONS SECTION
                // ====================
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                    child: Text(
                      'Featured',
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ====================
                // SESSIONS LIST
                // ====================
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final session = controller.sessions[index];
                    return _buildSessionListItem(session, controller, theme);
                  }, childCount: controller.sessions.length),
                ),

                // Bottom spacing
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          }),
        );
      },
    );
  }

  // ====================
  // SESSION LIST ITEM
  // ====================
  Widget _buildSessionListItem(
    dynamic session,
    CollectionDetailController controller,
    AppTheme theme,
  ) {
    return GestureDetector(
      onTap: () => controller.onSessionTap(session),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.borderColor, width: 1),
        ),
        child: Row(
          children: [
            // Teacher avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 60,
                height: 60,
                color: theme.accentColor.withValues(alpha: 0.3),
                child: Icon(Icons.person, color: theme.accentColor, size: 32),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${session.durationMinutes} - 15 min  •  ${session.instructor}',
                    style: TextStyle(color: theme.textSecondary, fontSize: 14),
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
