import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/chat/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
          () => ChatController(),
    );
  }
}
