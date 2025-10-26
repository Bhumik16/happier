import 'package:get/get.dart';
import 'courses_controller.dart';

/// ====================
/// COURSES BINDINGS
/// ====================
/// 
/// Dependency injection for Courses screen

class CoursesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoursesController>(() => CoursesController());
  }
}