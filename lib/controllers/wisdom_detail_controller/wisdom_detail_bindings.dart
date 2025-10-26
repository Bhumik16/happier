import 'package:get/get.dart';
import 'wisdom_detail_controller.dart';

class WisdomDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WisdomDetailController>(() => WisdomDetailController());
  }
}