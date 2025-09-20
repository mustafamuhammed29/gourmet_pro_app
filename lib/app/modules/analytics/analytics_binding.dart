import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/analytics/analytics_controller.dart';

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    // تهيئة الـ Controller الخاص بشاشة التحليلات
    Get.lazyPut<AnalyticsController>(
          () => AnalyticsController(),
    );
  }
}
