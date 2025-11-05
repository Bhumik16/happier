import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/sleep_audio_player_controller/sleep_audio_player_controller.dart';
import '../../../core/constants/app_text_styles.dart';

/// ====================
/// SLEEP AUDIO PLAYER VIEW
/// ====================
///
/// Specialized audio player for sleep sessions with timer UI

class SleepAudioPlayerView extends StatelessWidget {
  const SleepAudioPlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SleepAudioPlayerController>();

    return WillPopScope(
      onWillPop: () async {
        controller.stopPlayback();
        return true;
      },
      child: Scaffold(
        body: Obx(() {
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
                  // TOP BAR
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
                          onPressed: () {
                            controller.stopPlayback();
                            Get.back();
                          },
                        ),

                        // Right icons
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () {
                                Get.snackbar(
                                  'Download',
                                  'Download feature coming soon!',
                                );
                              },
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

                  // ====================
                  // CENTER CONTENT
                  // ====================
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            controller.sleep.title,
                            style: AppTextStyles.heading1.copyWith(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Instructor
                        Text(
                          'with ${controller.sleep.instructor}',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 80),

                        // ====================
                        // LARGE TIMER DISPLAY
                        // ====================
                        Text(
                          controller.formattedTime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 80,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 80),

                        // ====================
                        // PLAYBACK CONTROLS (✅ FIXED ICONS!)
                        // ====================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ✅ Skip backward 15s - CONSISTENT ICON
                            _buildControlButton(
                              onPressed: controller.skipBackward,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(
                                    Icons.replay_10,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    child: Text(
                                      '15',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 40),

                            // Play/Pause button
                            GestureDetector(
                              onTap: controller.togglePlayPause,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  controller.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: const Color(0xFF7B2D7F),
                                  size: 40,
                                ),
                              ),
                            ),

                            const SizedBox(width: 40),

                            // ✅ Skip forward 15s - CONSISTENT ICON
                            _buildControlButton(
                              onPressed: controller.skipForward,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(
                                    Icons.forward_10,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    child: Text(
                                      '15',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ====================
                  // PROGRESS BAR
                  // ====================
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 16,
                            ),
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            thumbColor: Colors.white,
                            overlayColor: Colors.white.withValues(alpha: 0.3),
                          ),
                          child: Slider(
                            value: controller.progress,
                            onChanged: (value) {
                              controller.seekTo(value);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.formattedCurrentTime,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                controller.formattedTotalTime,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return IconButton(onPressed: onPressed, icon: child, iconSize: 48);
  }
}
