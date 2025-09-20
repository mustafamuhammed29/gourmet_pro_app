import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/services/services_controller.dart';

class ServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicesController>(
          () => ServicesController(),
    );
  }
}
