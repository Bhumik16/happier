import 'package:get/get.dart';
import 'video_player_controller.dart';

/// ====================
/// VIDEO PLAYER BINDINGS
/// ====================

class VideoPlayerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoPlayerController>(() => VideoPlayerController());
  }
}