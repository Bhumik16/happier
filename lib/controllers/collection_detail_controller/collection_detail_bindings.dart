import 'package:get/get.dart';
import 'collection_detail_controller.dart';

class CollectionDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollectionDetailController>(() => CollectionDetailController());
  }
}