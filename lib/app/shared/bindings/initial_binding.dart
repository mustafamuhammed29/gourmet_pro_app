import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/data/providers/socket_provider.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // A single instance of ApiProvider will be created and shared across the app.
    Get.put<ApiProvider>(ApiProvider(), permanent: true);

    // ✨ ---  THE FIX --- ✨
    // AuthController should NOT be permanent.
    // It will be created by its own AuthBinding when needed.
    // We can remove the line below completely.
    // Get.put<AuthController>(AuthController(), permanent: true);

    // Make SocketProvider available globally
    Get.lazyPut<SocketProvider>(() => SocketProvider(), fenix: true);
  }
}
