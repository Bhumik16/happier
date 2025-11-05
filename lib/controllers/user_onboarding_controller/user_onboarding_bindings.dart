import 'package:get/get.dart';
import 'user_onboarding_controller.dart';
import '../auth_controller/auth_controller.dart';

class UserOnboardingBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize AuthController first (permanent)
    Get.put<AuthController>(AuthController(), permanent: true);

    // Then initialize UserOnboardingController
    Get.lazyPut<UserOnboardingController>(() => UserOnboardingController());
  }
}
