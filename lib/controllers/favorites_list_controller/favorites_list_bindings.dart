import 'package:get/get.dart';
import 'favorites_list_controller.dart';

class FavoritesListBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesListController>(() => FavoritesListController());
  }
}