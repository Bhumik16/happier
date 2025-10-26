import 'package:get/get.dart';
import 'podcast_audio_player_controller.dart';

class PodcastAudioPlayerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PodcastAudioPlayerController>(() => PodcastAudioPlayerController());
  }
}