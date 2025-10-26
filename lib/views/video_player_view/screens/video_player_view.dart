import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as video_player;
import '../../../controllers/video_player_controller/video_player_controller.dart';
import '../../../core/utils/navigation_helper.dart';

/// ====================
/// VIDEO PLAYER VIEW
/// ====================
/// 
/// Full-screen video player with Learn/Meditate tabs

class VideoPlayerView extends StatelessWidget {
  const VideoPlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoPlayerController>();
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading) {
          return _buildLoadingView();
        }
        
        if (!controller.isInitialized) {
          return _buildErrorView();
        }
        
        return _buildVideoPlayer(controller);
      }),
    );
  }
  
  // ====================
  // VIDEO PLAYER
  // ====================
  
  Widget _buildVideoPlayer(VideoPlayerController controller) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video
        Center(
          child: AspectRatio(
            aspectRatio: controller.videoController!.value.aspectRatio,
            child: video_player.VideoPlayer(controller.videoController!),
          ),
        ),
        
        // Controls Overlay
        Obx(() => AnimatedOpacity(
          opacity: controller.showControls ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: _buildControlsOverlay(controller),
        )),
        
        // Tap to show/hide controls
        GestureDetector(
          onTap: controller.toggleControls,
          behavior: HitTestBehavior.translucent,
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }
  
  // ====================
  // CONTROLS OVERLAY
  // ====================
  
  Widget _buildControlsOverlay(VideoPlayerController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header (Learn/Meditate tabs)
            _buildHeader(controller),
            
            const Spacer(),
            
            // Title & Session
            _buildTitleSection(controller),
            
            const SizedBox(height: 20),
            
            // Playback Controls
            _buildPlaybackControls(controller),
            
            const SizedBox(height: 20),
            
            // Progress Bar
            _buildProgressBar(controller),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  // ====================
  // HEADER (WITH TABS)
  // ====================
  
  Widget _buildHeader(VideoPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Learn/Meditate Toggle (Learn selected)
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                _buildTabButton('LEARN', true, () {}), // Current tab
                _buildTabButton('MEDITATE', false, controller.switchToMeditate),
              ],
            ),
          ),
          
          // Favorite Button
          IconButton(
            onPressed: () {
              Get.snackbar('Favorite', 'Favorites feature coming soon!');
            },
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
  
  // ====================
  // TITLE SECTION
  // ====================
  
  Widget _buildTitleSection(VideoPlayerController controller) {
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
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  // ====================
  // PLAYBACK CONTROLS
  // ====================
  
  Widget _buildPlaybackControls(VideoPlayerController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // CC Button
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
        
        // Rewind 10s
        IconButton(
          onPressed: () => controller.seekBackward(10),
          icon: const Icon(
            Icons.replay_10,
            color: Colors.white,
            size: 36,
          ),
        ),
        
        const SizedBox(width: 20),
        
        // Play/Pause
        Obx(() => IconButton(
          onPressed: controller.togglePlayPause,
          icon: Icon(
            controller.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 48,
          ),
        )),
        
        const SizedBox(width: 20),
        
        // Forward 10s
        IconButton(
          onPressed: () => controller.seekForward(10),
          icon: const Icon(
            Icons.forward_10,
            color: Colors.white,
            size: 36,
          ),
        ),
      ],
    );
  }
  
  // ====================
  // PROGRESS BAR
  // ====================
  
  Widget _buildProgressBar(VideoPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Obx(() => SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.2),
            ),
            child: Slider(
              value: controller.progress,
              onChanged: (value) {
                final position = controller.duration * value;
                controller.seek(position);
              },
            ),
          )),
          
          // Time Labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  controller.positionText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                )),
                Obx(() => Text(
                  controller.durationText,
                  style: const TextStyle(
                    color: Colors.white,
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
  // LOADING VIEW
  // ====================
  
  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
  
  // ====================
  // ERROR VIEW
  // ====================
  
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 60,
          ),
          const SizedBox(height: 20),
          const Text(
            'Failed to load video',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
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