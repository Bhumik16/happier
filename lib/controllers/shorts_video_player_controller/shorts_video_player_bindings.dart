import 'package:get/get.dart';
import 'shorts_video_player_controller.dart';

class ShortsVideoPlayerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShortsVideoPlayerController>(() => ShortsVideoPlayerController());
  }
}