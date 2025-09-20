import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/ai_features/review_responder/review_responder_controller.dart';

class ReviewResponderBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut يقوم بإنشاء نسخة من الـ Controller فقط عند الحاجة إليه لأول مرة
    Get.lazyPut<ReviewResponderController>(
          () => ReviewResponderController(),
    );
  }
}
