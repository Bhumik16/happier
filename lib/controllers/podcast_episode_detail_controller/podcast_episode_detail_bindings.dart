import 'package:get/get.dart';
import 'podcast_episode_detail_controller.dart';

class PodcastEpisodeDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PodcastEpisodeDetailController>(() => PodcastEpisodeDetailController());
  }
}