import 'package:get/get.dart';
import 'audio_player_controller.dart';

/// ====================
/// AUDIO PLAYER BINDINGS
/// ====================

class AudioPlayerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioPlayerController>(() => AudioPlayerController());
  }
}