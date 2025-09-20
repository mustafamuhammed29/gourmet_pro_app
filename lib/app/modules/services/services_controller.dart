import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';

class ServicesController extends GetxController {
  // In a real app, you might fetch services from an API.
  // For now, we'll use a static list.
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

  /// Handles the service request action.
  void requestService(String serviceName) {
    // In a real app, this might navigate to a detailed request form.
    // For now, we show a success confirmation.
    CustomSnackbar.showSuccess(
        'تم استلام طلبك لخدمة "$serviceName" وسنتواصل معك قريباً.');
  }
}
