import 'package:get/get.dart';
import 'sleeps_controller.dart';

/// ====================
/// SLEEPS BINDINGS
/// ====================
/// 
/// Dependency injection for Sleep screen

class SleepsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SleepsController>(() => SleepsController());
  }
}