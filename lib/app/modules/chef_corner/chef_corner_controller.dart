import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';

// A simple local model for current requests
class DishRequest {
  final String name;
  final String status;

  DishRequest(this.name, this.status);
}

class ChefCornerController extends GetxController {
  // --- STATE VARIABLES ---

  // Dummy list of current dish development requests.
  final List<DishRequest> currentRequests = [
    DishRequest('تارتار التونة الحار', 'قيد المراجعة'),
    DishRequest('موس الشوكولاتة النباتي', 'الوصفة مقترحة'),
    DishRequest('طبق دجاج بالزعتر', 'مكتمل'),
  ].obs;

  // --- PUBLIC METHODS ---

  /// Navigates the user to the chat screen to talk with an expert.
  void contactExpert() {
    // Navigate to the main chat screen
    Get.toNamed(Routes.chat);

    // Show an informational message
    CustomSnackbar.showInfo(
        'لقد تم توجيهك إلى فريق الدعم. اطلب المساعدة من خبرائنا.');
  }

  /// Placeholder for a future feature to see request details.
  void viewRequestDetails(DishRequest request) {
    Get.snackbar(
      'قيد التطوير',
      'سيتم تفعيل ميزة عرض تفاصيل الطلب لـ "${request.name}" قريباً.',
    );
  }
}

