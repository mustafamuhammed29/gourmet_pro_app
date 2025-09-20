import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/chef_corner/chef_corner_controller.dart';

class ChefCornerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChefCornerController>(
          () => ChefCornerController(),
    );
  }
}
