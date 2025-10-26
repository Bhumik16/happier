import 'package:get/get.dart';
import 'user_onboarding_controller.dart';

class UserOnboardingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserOnboardingController>(() => UserOnboardingController());
  }
}