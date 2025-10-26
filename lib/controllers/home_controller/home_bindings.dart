import 'package:get/get.dart';
import 'home_controller.dart';

/// ====================
/// HOME BINDINGS
/// ====================
/// 
/// Dependency injection for Home screen
class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}