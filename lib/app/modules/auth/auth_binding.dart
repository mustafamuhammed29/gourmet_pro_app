import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/auth/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Using lazyPut to initialize the controller only when it's first needed.
    // This is efficient for memory management.
    Get.lazyPut<AuthController>(
          () => AuthController(),
    );
  }
}

