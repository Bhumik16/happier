import 'package:get/get.dart';
import 'history_controller.dart';

class HistoryBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}