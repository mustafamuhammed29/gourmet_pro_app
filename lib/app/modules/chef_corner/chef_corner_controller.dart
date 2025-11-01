import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';

// نموذج بيانات طلب تطوير الطبق
class DishRequest {
  final int id;
  final String name;
  final String status;
  final String? description;

  DishRequest({
    required this.id,
    required this.name,
    required this.status,
    this.description,
  });

  factory DishRequest.fromJson(Map<String, dynamic> json) {
    return DishRequest(
      id: json['id'],
      name: json['dishName'],
      status: json['status'],
      description: json['description'],
    );
  }
}

class ChefCornerController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // --- STATE VARIABLES ---
  final RxList<DishRequest> currentRequests = <DishRequest>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChefRequests();
  }

  /// ✨ دالة جديدة لجلب طلبات تطوير الأطباق من الخادم
  Future<void> fetchChefRequests() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getMyChefRequests();

      if (response.isOk && response.body is List) {
        final List<dynamic> requestsJson = response.body;
        final requestsList = requestsJson
            .map((json) => DishRequest.fromJson(json))
            .toList();
        currentRequests.assignAll(requestsList);
      } else {
        throw Exception('Failed to fetch chef requests');
      }
    } catch (e) {
      CustomSnackbar.showError('فشل في جلب طلبات تطوير الأطباق.');
    } finally {
      isLoading.value = false;
    }
  }

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
      'تفاصيل الطلب',
      'الطبق: ${request.name}\nالحالة: ${request.status}\nالوصف: ${request.description ?? "لا يوجد"}',
    );
  }
}
