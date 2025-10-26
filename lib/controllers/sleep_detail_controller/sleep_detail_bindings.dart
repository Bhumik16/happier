import 'package:get/get.dart';
import 'sleep_detail_controller.dart';

class SleepDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SleepDetailController>(() => SleepDetailController());
  }
}