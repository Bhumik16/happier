import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/podcast_episode_detail_controller/podcast_episode_detail_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/podcast_episode_model.dart';
import '../../../core/utils/navigation_helper.dart';

/// ====================
/// PODCAST EPISODE DETAIL VIEW
/// ====================
///
/// Shows episode detail with Play/Resume button and Related episodes

class PodcastEpisodeDetailView extends StatelessWidget {
  const PodcastEpisodeDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PodcastEpisodeDetailController>();

    if (!Get.isRegistered<AppearanceController>()) {
      Get.put(AppearanceController());
    }

    final AppTheme theme = AppTheme();

    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Obx(() {
            if (controller.isLoading || controller.episode == null) {
              return Center(
                child: CircularProgressIndicator(color: theme.accentColor),
              );
            }

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Top Bar
                    _buildTopBar(controller, theme),

                    const SizedBox(height: 20),

                    // Episode Cover
                    _buildCoverImage(controller, theme),

                    const SizedBox(height: 20),

                    // Subscriber Badge
                    _buildSubscriberBadge(),

                    const SizedBox(height: 16),

                    // Episode Title
                    _buildEpisodeTitle(controller, theme),

                    const SizedBox(height: 8),

                    // Podcast Name
                    _buildPodcastName(controller),

                    const SizedBox(height: 40),

                    // Play/Resume Button
                    _buildPlayButton(controller, theme),

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

  // ====================
  // TOP BAR
  // ====================

  Widget _buildTopBar(
    PodcastEpisodeDetailController controller,
    AppTheme theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          IconButton(
            onPressed: () => NavigationHelper.goBackSimple(),
            icon: Icon(Icons.arrow_back, color: theme.iconPrimary, size: 28),
          ),

          // Right Actions
          Row(
            children: [
              // Download Button
              IconButton(
                onPressed: () {
                  Get.snackbar(
                    'Download',
                    'Downloading episode...',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: Icon(Icons.download, color: theme.iconPrimary, size: 24),
              ),

              // Share Button
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

              // Favorite Button
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

  // ====================
  // COVER IMAGE
  // ====================

  Widget _buildCoverImage(
    PodcastEpisodeDetailController controller,
    AppTheme theme,
  ) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          controller.episode!.thumbnailImage,
          width: 320,
          height: 320,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 320,
              height: 320,
              color: theme.cardColor,
              child: Icon(Icons.podcasts, size: 80, color: theme.textSecondary),
            );
          },
        ),
      ),
    );
  }

  // ====================
  // SUBSCRIBER BADGE
  // ====================

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

  // ====================
  // EPISODE TITLE
  // ====================

  Widget _buildEpisodeTitle(
    PodcastEpisodeDetailController controller,
    AppTheme theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        controller.episode!.title,
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

  // ====================
  // PODCAST NAME
  // ====================

  Widget _buildPodcastName(PodcastEpisodeDetailController controller) {
    return Text(
      controller.episode!.podcastName,
      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }

  // ====================
  // PLAY BUTTON (✅ ALWAYS BLACK!)
  // ====================

  Widget _buildPlayButton(
    PodcastEpisodeDetailController controller,
    AppTheme theme,
  ) {
    return GestureDetector(
      onTap: controller.playEpisode,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          // ✅ ALWAYS BLACK - even in light mode!
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ ALWAYS WHITE ICON
            const Icon(Icons.play_arrow, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Text(
              controller.buttonText,
              style: const TextStyle(
                // ✅ ALWAYS WHITE TEXT
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====================
  // EPISODE NOTES
  // ====================

  Widget _buildEpisodeNotes(
    PodcastEpisodeDetailController controller,
    AppTheme theme,
  ) {
    if (controller.episode!.description == null) {
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
                controller.episode!.duration,
                style: TextStyle(color: theme.textSecondary, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            controller.episode!.description!,
            style: TextStyle(color: theme.textPrimary, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ====================
  // RELATED EPISODES
  // ====================

  Widget _buildRelatedEpisodes(
    PodcastEpisodeDetailController controller,
    AppTheme theme,
  ) {
    final related = controller.allEpisodes
        .where((ep) => ep.id != controller.episode!.id)
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

        // Related Episodes List
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

  // ====================
  // RELATED EPISODE ITEM
  // ====================

  Widget _buildRelatedEpisodeItem(
    PodcastEpisodeModel episode,
    PodcastEpisodeDetailController controller,
    AppTheme theme,
  ) {
    return InkWell(
      onTap: () => controller.playRelatedEpisode(episode),
      child: Row(
        children: [
          // Thumbnail
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

          // Info
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
