import 'package:get/get.dart';
import 'milestones_controller.dart';

class MilestonesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MilestonesController>(() => MilestonesController());
  }
}