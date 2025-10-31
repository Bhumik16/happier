import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/audio_player_controller/audio_player_controller.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/constants/app_text_styles.dart';

/// ====================
/// AUDIO PLAYER VIEW
/// ====================
///
/// Full-screen audio player with timer and gradient background

class AudioPlayerView extends StatelessWidget {
  const AudioPlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AudioPlayerController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF4DB8C4), const Color(0xFFE8A85C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(controller),

              // Main Content
              Expanded(child: _buildMainContent(controller)),

              // Controls
              _buildControls(controller),

              // Progress Bar
              _buildProgressBar(controller),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ====================
  // HEADER
  // ====================

  Widget _buildHeader(AudioPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Learn/Meditate Toggle (Meditate selected)
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                _buildTabButton('LEARN', false, controller.switchToLearn),
                _buildTabButton('MEDITATE', true, () {}),
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
  // MAIN CONTENT (Timer)
  // ====================

  Widget _buildMainContent(AudioPlayerController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Course Title
        Text(
          controller.session?.title ?? 'The Basics',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // Session Number
        Text(
          'Session ${controller.session?.sessionNumber ?? 1}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 60),

        // Large Timer
        Obx(
          () => Text(
            controller.remainingText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 80,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  // ====================
  // CONTROLS
  // ====================

  Widget _buildControls(AudioPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Rewind 10s
          IconButton(
            onPressed: () => controller.seekBackward(10),
            icon: Icon(
              Icons.replay_10,
              color: Colors.white.withValues(alpha: 0.9),
              size: 36,
            ),
          ),

          // Play/Pause
          Obx(
            () => GestureDetector(
              onTap: controller.togglePlayPause,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: const Color(0xFF4DB8C4),
                  size: 40,
                ),
              ),
            ),
          ),

          // Forward 10s
          IconButton(
            onPressed: () => controller.seekForward(10),
            icon: Icon(
              Icons.forward_10,
              color: Colors.white.withValues(alpha: 0.9),
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  // ====================
  // PROGRESS BAR
  // ====================

  Widget _buildProgressBar(AudioPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        children: [
          Obx(
            () => SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                thumbColor: Colors.white,
                overlayColor: Colors.white.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: controller.progress,
                onChanged: (value) {
                  final position = controller.duration * value;
                  controller.seek(position);
                },
              ),
            ),
          ),

          // Time Labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    controller.positionText,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    controller.durationText,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
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
}
