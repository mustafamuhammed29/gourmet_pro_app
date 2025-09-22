import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/promo_tools/promo_tools_controller.dart';

class PromoToolsBinding extends Bindings {
  @override
  void dependencies() {
    // We use lazyPut with fenix: true to ensure the controller is always
    // fresh and available when navigating to this screen.
    Get.lazyPut<PromoToolsController>(
          () => PromoToolsController(),
      fenix: true,
    );
  }
}

