import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/ai_features/social_post_generator/social_post_generator_controller.dart';

class SocialPostGeneratorBinding extends Bindings {
  @override
  void dependencies() {
    // تهيئة الـ Controller الخاص بمولد المنشورات
    Get.lazyPut<SocialPostGeneratorController>(
          () => SocialPostGeneratorController(),
    );
  }
}
