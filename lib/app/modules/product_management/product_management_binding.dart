import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/product_management/product_management_controller.dart';

class ProductManagementBinding extends Bindings {
  @override
  void dependencies() {
    // We use lazyPut to create an instance of the controller only when it's needed for the first time.
    Get.lazyPut<ProductManagementController>(
          () => ProductManagementController(),
    );
  }
}
