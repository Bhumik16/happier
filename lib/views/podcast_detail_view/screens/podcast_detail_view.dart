import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/podcast_detail_controller/podcast_detail_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/podcast_episode_model.dart';
import '../../../core/utils/navigation_helper.dart';

/// ====================
/// PODCAST DETAIL VIEW
/// ====================
/// 
/// Shows podcast information and episode list

class PodcastDetailView extends StatelessWidget {
  const PodcastDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PodcastDetailController>();
    
    // ✅ Ensure AppearanceController is registered
    if (!Get.isRegistered<AppearanceController>()) {
      Get.put(AppearanceController());
    }
    
    final AppTheme theme = AppTheme();
    
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Obx(() {
            if (controller.isLoading || controller.podcast == null) {
              return Center(
                child: CircularProgressIndicator(color: theme.accentColor),
              );
            }
            
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  // App Bar with back and share buttons
                  _buildSliverAppBar(theme),
                  
                  // Podcast Cover Image
                  SliverToBoxAdapter(
                    child: _buildPodcastCover(controller, theme),
                  ),
                  
                  // Podcast Info Section
                  SliverToBoxAdapter(
                    child: _buildPodcastInfo(controller, theme),
                  ),
                  
                  // Episodes List
                  SliverToBoxAdapter(
                    child: _buildEpisodesList(controller, theme),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
  
  // ====================
  // APP BAR
  // ====================
  
  Widget _buildSliverAppBar(AppTheme theme) {
    return SliverAppBar(
      backgroundColor: theme.appBarColor,
      elevation: 0,
      pinned: false,
      floating: true,
      leading: IconButton(
        onPressed: () => NavigationHelper.goBackSimple(),
        icon: Icon(
          Icons.arrow_back,
          color: theme.iconPrimary,
          size: 28,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.snackbar('Share', 'Sharing podcast...',
                snackPosition: SnackPosition.BOTTOM);
          },
          icon: Icon(
            Icons.share,
            color: theme.iconPrimary,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
  
  // ====================
  // PODCAST COVER IMAGE
  // ====================
  
  Widget _buildPodcastCover(PodcastDetailController controller, AppTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: controller.podcast!.thumbnailImage != null
              ? Image.asset(
                  controller.podcast!.thumbnailImage!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 300,
                      height: 300,
                      color: theme.cardColor,
                      child: Icon(
                        Icons.podcasts,
                        size: 80,
                        color: theme.textSecondary,
                      ),
                    );
                  },
                )
              : Container(
                  width: 300,
                  height: 300,
                  color: theme.cardColor,
                  child: Icon(
                    Icons.podcasts,
                    size: 80,
                    color: theme.textSecondary,
                  ),
                ),
        ),
      ),
    );
  }
  
  // ====================
  // PODCAST INFO
  // ====================
  
  Widget _buildPodcastInfo(PodcastDetailController controller, AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "PODCAST" label
          Text(
            'PODCAST',
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          
          // Title
          Text(
            controller.podcast!.title,
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Subscriber Only Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.amber,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.amber,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Subscriber Only Show',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Description
          if (controller.podcast!.description != null)
            Text(
              controller.podcast!.description!,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  // ====================
  // EPISODES LIST
  // ====================
  
  Widget _buildEpisodesList(PodcastDetailController controller, AppTheme theme) {
    if (controller.episodes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            'No episodes available',
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: controller.episodes.length,
      separatorBuilder: (context, index) => Divider(
        color: theme.dividerColor,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final episode = controller.episodes[index];
        return _buildEpisodeItem(episode, controller, theme);
      },
    );
  }
  
  // ====================
  // EPISODE ITEM
  // ====================
  
  Widget _buildEpisodeItem(
    PodcastEpisodeModel episode,
    PodcastDetailController controller,
    AppTheme theme,
  ) {
    return InkWell(
      onTap: () => controller.onEpisodeTap(episode),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            // Episode Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                episode.thumbnailImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: theme.cardColor,
                    child: Icon(
                      Icons.podcasts,
                      color: theme.textSecondary,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            
            // Episode Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  Text(
                    episode.date,
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Title
                  Text(
                    episode.title,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Duration
                  Text(
                    episode.duration,
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 14,
                    ),
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