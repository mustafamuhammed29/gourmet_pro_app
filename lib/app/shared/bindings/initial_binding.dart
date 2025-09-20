import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import '../../data/providers/socket_provider.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // هنا نقوم بتسجيل كل الخدمات العامة التي يحتاجها التطبيق
    Get.put(ApiProvider(), permanent: true);
    Get.put(SocketProvider(), permanent: true); // <-- هذا هو السطر الجديد
  }
}

