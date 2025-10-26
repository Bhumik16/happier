import 'package:get/get.dart';
import 'podcast_detail_controller.dart';

class PodcastDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PodcastDetailController>(() => PodcastDetailController());
  }
}