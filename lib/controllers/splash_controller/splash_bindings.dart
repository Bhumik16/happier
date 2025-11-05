import 'package:get/get.dart';
import 'splash_controller.dart';
import '../auth_controller/auth_controller.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthController is available
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }

    // ✅ Use Get.put() instead of Get.lazyPut() to initialize immediately
    Get.put<SplashController>(SplashController());
  }
}
