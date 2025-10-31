import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/podcast_audio_player_controller/podcast_audio_player_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/podcast_episode_model.dart';
import '../../../core/utils/navigation_helper.dart';

/// ====================
/// PODCAST AUDIO PLAYER VIEW
/// ====================
///
/// Full-screen audio player for podcast episodes

class PodcastAudioPlayerView extends StatelessWidget {
  const PodcastAudioPlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PodcastAudioPlayerController>();

    if (!Get.isRegistered<AppearanceController>()) {
      Get.put(AppearanceController());
    }

    final AppTheme theme = AppTheme();

    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Obx(() {
            if (controller.isLoading || controller.currentEpisode == null) {
              return Center(
                child: CircularProgressIndicator(color: theme.accentColor),
              );
            }

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Top Bar (Back, Download, Share, Favorite)
                    _buildTopBar(controller, theme),

                    const SizedBox(height: 20),

                    // Podcast Cover Image
                    _buildCoverImage(controller, theme),

                    const SizedBox(height: 20),

                    // Subscriber Only Badge
                    _buildSubscriberBadge(),

                    const SizedBox(height: 16),

                    // Episode Title
                    _buildEpisodeTitle(controller, theme),

                    const SizedBox(height: 8),

                    // Podcast Name
                    _buildPodcastName(controller),

                    const SizedBox(height: 40),

                    // Playback Controls
                    _buildPlaybackControls(controller, theme),

                    const SizedBox(height: 30),

                    // Progress Bar
                    _buildProgressBar(controller, theme),

                    const SizedBox(height: 40),

                    // Episode Notes
                    _buildEpisodeNotes(controller, theme),

                    const SizedBox(height: 20),

                    // Related Episodes
                    _buildRelatedEpisodes(controller, theme),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildTopBar(PodcastAudioPlayerController controller, AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => NavigationHelper.goBackSimple(),
            icon: Icon(Icons.arrow_back, color: theme.iconPrimary, size: 28),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.snackbar(
                    'Already Available',
                    'This episode is already downloaded and available offline.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                },
                icon: Icon(Icons.download, color: theme.iconPrimary, size: 24),
              ),
              IconButton(
                onPressed: () {
                  Get.snackbar(
                    'Share',
                    'Sharing episode...',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: Icon(Icons.share, color: theme.iconPrimary, size: 24),
              ),
              Obx(
                () => IconButton(
                  onPressed: controller.toggleFavorite,
                  icon: Icon(
                    controller.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: controller.isFavorite
                        ? Colors.red
                        : theme.iconPrimary,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(
    PodcastAudioPlayerController controller,
    AppTheme theme,
  ) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          controller.currentEpisode!.thumbnailImage,
          width: 280,
          height: 280,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 280,
              height: 280,
              color: theme.cardColor,
              child: Icon(Icons.podcasts, size: 80, color: theme.textSecondary),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubscriberBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.amber, size: 14),
            const SizedBox(width: 6),
            Text(
              'Subscriber Only Show',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodeTitle(
    PodcastAudioPlayerController controller,
    AppTheme theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        controller.currentEpisode!.title,
        style: TextStyle(
          color: theme.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPodcastName(PodcastAudioPlayerController controller) {
    return Text(
      controller.currentEpisode!.podcastName,
      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPlaybackControls(
    PodcastAudioPlayerController controller,
    AppTheme theme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: controller.skipBackward,
          icon: Icon(Icons.replay_10, color: theme.iconPrimary, size: 40),
        ),
        const SizedBox(width: 40),
        Obx(
          () => GestureDetector(
            onTap: controller.togglePlayPause,
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.black,
                size: 48,
              ),
            ),
          ),
        ),
        const SizedBox(width: 40),
        IconButton(
          onPressed: controller.skipForward,
          icon: Icon(Icons.forward_10, color: theme.iconPrimary, size: 40),
        ),
      ],
    );
  }

  Widget _buildProgressBar(
    PodcastAudioPlayerController controller,
    AppTheme theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Obx(
            () => SliderTheme(
              data: SliderThemeData(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                trackHeight: 3,
                activeTrackColor: theme.textPrimary,
                inactiveTrackColor: theme.cardColor,
                thumbColor: theme.textPrimary,
              ),
              child: Slider(
                value: controller.position.inSeconds.toDouble(),
                max: controller.duration.inSeconds.toDouble() > 0
                    ? controller.duration.inSeconds.toDouble()
                    : 1.0,
                onChanged: (value) {
                  controller.seekTo(Duration(seconds: value.toInt()));
                },
              ),
            ),
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.formattedPosition,
                    style: TextStyle(color: theme.textSecondary, fontSize: 12),
                  ),
                  Text(
                    controller.formattedDuration,
                    style: TextStyle(color: theme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeNotes(
    PodcastAudioPlayerController controller,
    AppTheme theme,
  ) {
    if (controller.currentEpisode!.description == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Episode Notes',
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                controller.currentEpisode!.duration,
                style: TextStyle(color: theme.textSecondary, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            controller.currentEpisode!.description!,
            style: TextStyle(color: theme.textPrimary, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedEpisodes(
    PodcastAudioPlayerController controller,
    AppTheme theme,
  ) {
    final related = controller.relatedEpisodes
        .where((ep) => ep.id != controller.currentEpisode!.id)
        .take(3)
        .toList();

    if (related.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Related',
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          itemCount: related.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return _buildRelatedEpisodeItem(related[index], controller, theme);
          },
        ),
      ],
    );
  }

  Widget _buildRelatedEpisodeItem(
    PodcastEpisodeModel episode,
    PodcastAudioPlayerController controller,
    AppTheme theme,
  ) {
    return InkWell(
      onTap: () => controller.playRelatedEpisode(episode),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              episode.thumbnailImage,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  color: theme.cardColor,
                  child: Icon(
                    Icons.podcasts,
                    color: theme.textSecondary,
                    size: 30,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  episode.title,
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Episode • ${episode.podcastName}',
                  style: TextStyle(color: theme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
