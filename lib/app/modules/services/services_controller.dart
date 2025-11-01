import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';

class ServicesController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  
  // قائمة الخدمات المتاحة
  final services = [
    {
      'title': 'استشارات الطهي',
      'description': 'نصائح الخبراء لتصميم القائمة وتطوير الوصفات.',
      'icon': Icons.restaurant_menu_outlined,
    },
    {
      'title': 'التسويق الرقمي',
      'description': 'حملات إعلانية احترافية لزيادة وصول مطعمك.',
      'icon': Icons.campaign_outlined,
    },
    {
      'title': 'تصوير احترافي',
      'description': 'صور عالية الجودة لأطباقك تثير شهية الزبائن.',
      'icon': Icons.camera_alt_outlined,
    },
  ];

  final isLoading = false.obs;

  /// ✨ تم تحديث الدالة لإرسال طلب حقيقي إلى الخادم
  Future<void> requestService(String serviceName) async {
    try {
      isLoading.value = true;
      
      final response = await _apiProvider.requestService({
        'serviceName': serviceName,
        'description': 'طلب خدمة $serviceName',
      });

      if (response.isOk) {
        CustomSnackbar.showSuccess(
            'تم استلام طلبك لخدمة "$serviceName" وسنتواصل معك قريباً.');
      } else {
        throw Exception('Failed to request service');
      }
    } catch (e) {
      CustomSnackbar.showError('حدث خطأ أثناء إرسال الطلب. حاول مرة أخرى.');
    } finally {
      isLoading.value = false;
    }
  }
}
