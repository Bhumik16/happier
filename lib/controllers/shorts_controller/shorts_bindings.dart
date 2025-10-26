import 'package:get/get.dart';
import 'shorts_controller.dart';

/// ====================
/// SHORTS BINDINGS
/// ====================
/// 
/// Dependency injection for Shorts screen

class ShortsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShortsController>(() => ShortsController());
  }
}