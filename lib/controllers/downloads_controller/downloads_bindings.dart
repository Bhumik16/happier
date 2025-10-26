import 'package:get/get.dart';
import 'downloads_controller.dart';

class DownloadsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DownloadsController>(() => DownloadsController());
  }
}