import 'package:get/get.dart';
import 'premium_upgrade_controller.dart';

class PremiumUpgradeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PremiumUpgradeController>(() => PremiumUpgradeController());
  }
}