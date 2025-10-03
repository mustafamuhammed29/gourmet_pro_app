import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/data/providers/socket_provider.dart'; // <-- ١. إضافة الاستيراد
import 'package:gourmet_pro_app/app/modules/auth/auth_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // A single instance of ApiProvider will be created and shared across the app.
    Get.put<ApiProvider>(ApiProvider(), permanent: true);

    // Make AuthController permanent so it's not disposed
    Get.put<AuthController>(AuthController(), permanent: true);

    // Make SocketProvider available globally
    Get.lazyPut<SocketProvider>(() => SocketProvider(), fenix: true); // <-- ٢. إضافة السطر الجديد
  }
}

