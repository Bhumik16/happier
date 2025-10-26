import 'package:get/get.dart';
import 'subscription_controller.dart';

class SubscriptionBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionController>(() => SubscriptionController());
  }
}