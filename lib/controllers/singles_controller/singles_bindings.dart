import 'package:get/get.dart';
import 'singles_controller.dart';

/// ====================
/// SINGLES BINDINGS
/// ====================
/// 
/// Dependency injection for Singles screen

class SinglesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SinglesController>(() => SinglesController());
  }
}