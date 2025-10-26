import 'package:get/get.dart';
import 'chatbot_controller.dart';

class ChatbotBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatbotController>(() => ChatbotController());
  }
}