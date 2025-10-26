import 'package:get/get.dart';
import 'sleep_audio_player_controller.dart';

class SleepAudioPlayerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SleepAudioPlayerController>(() => SleepAudioPlayerController());
  }
}