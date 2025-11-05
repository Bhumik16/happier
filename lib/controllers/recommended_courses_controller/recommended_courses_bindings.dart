import 'package:get/get.dart';
import 'recommended_courses_controller.dart';

class RecommendedCoursesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecommendedCoursesController>(
      () => RecommendedCoursesController(),
    );
  }
}
