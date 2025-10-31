import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as video_player;
import '../../../controllers/unified_player_controller/unified_player_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/navigation_helper.dart';

/// ====================
/// UNIFIED PLAYER VIEW
/// ====================
/// Single screen with Learn (Video) and Meditate (Audio) tabs

class UnifiedPlayerView extends StatelessWidget {
  const UnifiedPlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UnifiedPlayerController>();
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLearnTab) {
          return _buildVideoPlayer(controller);
        } else {
          return _buildAudioPlayer(controller);
        }
      }),
    );
  }
  
  // ====================
  // VIDEO PLAYER (LEARN TAB)
  // ====================
  
  Widget _buildVideoPlayer(UnifiedPlayerController controller) {
    if (controller.videoLoading) {
      return _buildLoadingView();
    }
    
    if (!controller.videoInitialized) {
      return _buildErrorView('Failed to load video');
    }
    
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: controller.videoController!.value.aspectRatio,
            child: video_player.VideoPlayer(controller.videoController!),
          ),
        ),
        Obx(() => Visibility(
          visible: !controller.showVideoControls,
          child: GestureDetector(
            onTap: controller.toggleVideoControls,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
        )),
        Obx(() => AnimatedOpacity(
          opacity: controller.showVideoControls ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !controller.showVideoControls,
            child: _buildVideoControls(controller),
          ),
        )),
      ],
    );
  }
  
  Widget _buildVideoControls(UnifiedPlayerController controller) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withValues(alpha: 0.7),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(controller),
              const Spacer(),
              _buildTitle(controller),
              const SizedBox(height: 20),
              _buildVideoPlaybackControls(controller),
              const SizedBox(height: 20),
              _buildVideoProgressBar(controller),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildVideoPlaybackControls(UnifiedPlayerController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            Get.snackbar('Subtitles', 'Subtitles feature coming soon!');
          },
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        const SizedBox(width: 20),
        IconButton(
          onPressed: () => controller.seekVideoBackward(10),
          icon: const Icon(Icons.replay_10, color: Colors.white, size: 36),
        ),
        const SizedBox(width: 20),
        Obx(() => IconButton(
          onPressed: controller.toggleVideoPlayPause,
          icon: Icon(
            controller.videoPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 56,
          ),
        )),
        const SizedBox(width: 20),
        IconButton(
          onPressed: () => controller.seekVideoForward(10),
          icon: const Icon(Icons.forward_10, color: Colors.white, size: 36),
        ),
      ],
    );
  }
  
  Widget _buildVideoProgressBar(UnifiedPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Obx(() => SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackHeight: 3,
            ),
            child: Slider(
              value: controller.videoProgress,
              onChanged: (value) {
                final position = controller.videoDuration * value;
                controller.seekVideo(position);
              },
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  controller.videoPositionText,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                )),
                Obx(() => Text(
                  controller.videoDurationText,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // ====================
  // AUDIO PLAYER (MEDITATE TAB)
  // ====================
  
  Widget _buildAudioPlayer(UnifiedPlayerController controller) {
    if (controller.audioLoading) {
      return _buildLoadingView();
    }
    
    if (!controller.audioInitialized) {
      return _buildErrorView('Audio not available');
    }
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4DB8C4), Color(0xFFE8A85C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(controller),
            Expanded(child: _buildAudioContent(controller)),
            _buildAudioControls(controller),
            _buildAudioProgressBar(controller),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAudioContent(UnifiedPlayerController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => Text(
            controller.audioRemainingText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.w300,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          )),
          const SizedBox(height: 12),
          Text(
            'Time Remaining',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              controller.session?.title ?? 'Meditation',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAudioControls(UnifiedPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => controller.seekAudioBackward(15),
            iconSize: 56,
            icon: Stack(
              alignment: Alignment.center,
              children: const [
                Icon(Icons.fast_rewind, color: Colors.white, size: 40),
                Positioned(
                  bottom: 10,
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
          Obx(() => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: controller.toggleAudioPlayPause,
              icon: Icon(
                controller.audioPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.primary,
                size: 48,
              ),
              iconSize: 48,
            ),
          )),
          const SizedBox(width: 40),
          IconButton(
            onPressed: () => controller.seekAudioForward(15),
            iconSize: 56,
            icon: Stack(
              alignment: Alignment.center,
              children: const [
                Icon(Icons.fast_forward, color: Colors.white, size: 40),
                Positioned(
                  bottom: 10,
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
    );
  }
  
  Widget _buildAudioProgressBar(UnifiedPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Speed: ',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              Obx(() => DropdownButton<double>(
                value: controller.audioSpeed,
                dropdownColor: AppColors.primary,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                underline: Container(),
                items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                    .map((speed) => DropdownMenuItem(
                          value: speed,
                          child: Text('${speed}x'),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.setAudioSpeed(value);
                  }
                },
              )),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackHeight: 3,
            ),
            child: Slider(
              value: controller.audioProgress,
              onChanged: (value) {
                final position = controller.audioDuration * value;
                controller.seekAudio(position);
              },
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  controller.audioPositionText,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                )),
                Obx(() => Text(
                  controller.audioDurationText,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // ====================
  // HEADER (SHARED BY BOTH PLAYERS)
  // ====================
  
  Widget _buildHeader(UnifiedPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              controller.stopPlayback();
              NavigationHelper.goBackSimple();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTabButton(
                      'LEARN',
                      controller.isLearnTab,
                      controller.switchToLearnTab,
                    ),
                    _buildTabButton(
                      'MEDITATE',
                      controller.isMeditateTab,
                      controller.switchToMeditateTab,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ✅ HEART BUTTON (FAVORITE)
          Obx(() => IconButton(
            onPressed: controller.toggleFavorite,
            icon: Icon(
              controller.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: controller.isFavorite ? Colors.red : Colors.white,
              size: 28,
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
  
  Widget _buildTitle(UnifiedPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            controller.session?.title ?? 'The Basics',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Session ${controller.session?.sessionNumber ?? 1}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }
  
  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 60),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => NavigationHelper.goBackSimple(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
