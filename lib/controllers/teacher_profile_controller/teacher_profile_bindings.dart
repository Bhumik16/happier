import 'package:get/get.dart';
import 'teacher_profile_controller.dart';

class TeacherProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherProfileController>(() => TeacherProfileController());
  }
}
