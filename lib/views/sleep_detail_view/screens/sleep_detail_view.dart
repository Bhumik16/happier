import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/sleep_detail_controller/sleep_detail_controller.dart';
import '../../../core/utils/navigation_helper.dart';

/// ====================
/// SLEEP DETAIL VIEW
/// ====================
///
/// Shows sleep session details with play button and duration selector

class SleepDetailView extends StatelessWidget {
  const SleepDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SleepDetailController>();

    return Scaffold(
      body: Obx(() {
        final sleep = controller.sleep;

        // ✅ Gradient background stays the same - purple/pink looks great in both themes
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFB74B9E), // Purple/Pink gradient
                Color(0xFF7B2D7F),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // ====================
                // TOP BAR (Download, Share, Heart)
                // ====================
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => NavigationHelper.goBackSimple(),
                      ),

                      // Right icons
                      Row(
                        children: [
                          // Download button (simplified - no status tracking)
                          IconButton(
                            icon: const Icon(
                              Icons.download,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: controller.downloadSleep,
                          ),
                          IconButton(
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
                          IconButton(
                            icon: Icon(
                              controller.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: controller.isFavorite
                                  ? Colors.red
                                  : Colors.white,
                              size: 28,
                            ),
                            onPressed: controller.toggleFavorite,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),

                          // ====================
                          // TITLE SECTION
                          // ====================
                          Text(
                            sleep.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'with ${sleep.instructor}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 60),

                          // ====================
                          // PLAY BUTTON
                          // ====================
                          GestureDetector(
                            onTap: controller.onPlayTap,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 64,
                              ),
                            ),
                          ),

                          const SizedBox(height: 60),

                          // ====================
                          // DESCRIPTION SECTION
                          // ====================
                          if (sleep.description != null &&
                              sleep.description!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                sleep.description!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          const SizedBox(height: 40),

                          // ====================
                          // DURATION DROPDOWN (Only if has range)
                          // ====================
                          if (controller.hasDurationOptions) ...[
                            GestureDetector(
                              onTap: controller.showDurationPicker,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${controller.selectedDuration} min',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
