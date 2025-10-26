import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../controllers/shorts_video_player_controller/shorts_video_player_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// ====================
/// SHORTS VIDEO PLAYER VIEW
/// ====================
/// 
/// Full-screen video player for Practice In Action and Wisdom Clips

class ShortsVideoPlayerView extends GetView<ShortsVideoPlayerController> {
  const ShortsVideoPlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return _buildLoadingView();
          }

          if (controller.hasError) {
            return _buildErrorView();
          }

          return Stack(
            children: [
              // Video Player (Full Screen Portrait)
              Center(
                child: SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.videoController!.value.size.width,
                      height: controller.videoController!.value.size.height,
                      child: VideoPlayer(controller.videoController!),
                    ),
                  ),
                ),
              ),

              // Top Bar (Heart icon only on right)
              _buildTopBar(),

              // Title and Instructor (Above video area, at top)
              _buildTitleOverlay(),

              // Video Controls Overlay (Bottom)
              _buildControlsOverlay(),
            ],
          );
        }),
      ),
    );
  }

  // ====================
  // TITLE OVERLAY (TOP - ABOVE VIDEO)
  // ====================

  Widget _buildTitleOverlay() {
    return Positioned(
      top: 60, // Below the heart icon
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              controller.short.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w300,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),

            if (controller.short.instructor != null) ...[
              const SizedBox(height: 8),
              Text(
                'with ${controller.short.instructor}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ====================
  // CONTROLS OVERLAY (BOTTOM)
  // ====================

  Widget _buildControlsOverlay() {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          
          // Bottom Controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              children: [
                // Playback Controls Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CC Button
                    IconButton(
                      onPressed: () {
                        Get.snackbar(
                          'Subtitles',
                          'Coming soon',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      icon: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'CC',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Skip Backward
                    IconButton(
                      onPressed: controller.skipBackward,
                      icon: const Icon(
                        Icons.replay_10,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Play/Pause
                    GestureDetector(
                      onTap: controller.togglePlayPause,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          controller.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.black,
                          size: 36,
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Skip Forward
                    IconButton(
                      onPressed: controller.skipForward,
                      icon: const Icon(
                        Icons.forward_10,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),

                    const Spacer(),

                    const SizedBox(width: 48), // Balance for CC button
                  ],
                ),

                const SizedBox(height: 16),

                // Progress Bar
                if (controller.videoController != null)
                  VideoProgressIndicator(
                    controller.videoController!,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.white,
                      bufferedColor: Colors.white38,
                      backgroundColor: Colors.white24,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),

                // Time Display
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(controller.currentPosition),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _formatDuration(controller.totalDuration),
                        style: const TextStyle(
                          color: Colors.white,
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
    );
  }

  // ====================
  // TOP BAR (HEART ONLY)
  // ====================

  Widget _buildTopBar() {
    return Positioned(
      top: 16,
      right: 16,
      child: IconButton(
        onPressed: controller.toggleFavorite,
        icon: Icon(
          controller.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: controller.isFavorite ? Colors.red : Colors.white,
          size: 32,
        ),
      ),
    );
  }

  // ====================
  // LOADING VIEW
  // ====================

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  // ====================
  // ERROR VIEW
  // ====================

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              controller.errorMessage,
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  // ====================
  // FORMAT DURATION
  // ====================

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}