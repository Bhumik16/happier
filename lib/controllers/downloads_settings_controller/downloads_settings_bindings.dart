import 'package:get/get.dart';
import 'downloads_settings_controller.dart';

class DownloadsSettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DownloadsSettingsController>(() => DownloadsSettingsController());
  }
}