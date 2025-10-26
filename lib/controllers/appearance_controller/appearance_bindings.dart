import 'package:get/get.dart';
import 'appearance_controller.dart';

class AppearanceBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppearanceController>(() => AppearanceController());
  }
}