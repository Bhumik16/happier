import 'package:get/get.dart';
import 'unified_player_controller.dart';

class UnifiedPlayerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UnifiedPlayerController>(() => UnifiedPlayerController());
  }
}