import 'package:get/get.dart';
import 'course_detail_controller.dart';

/// ====================
/// COURSE DETAIL BINDINGS
/// ====================

class CourseDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseDetailController>(() => CourseDetailController());
  }
}