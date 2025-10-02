import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';

import '../main_wrapper/main_menu_screen.dart';

class DashboardController extends GetxController {
  // --- STATE VARIABLES ---
  final restaurantName = 'مطعم الذواقة'.obs;

  // --- Promo Generator State ---
  // The TextEditingController has been removed from here and is now managed by the widget itself.
  final isPromoLoading = false.obs;
  final promoIdeaResult = ''.obs;

  // --- PUBLIC METHODS ---

  /// Opens the main menu screen as a full-screen dialog.
  void openMainMenu() {
    Get.dialog(
      const MainMenuScreen(),
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
    );
  }

  /// This method now accepts the theme text directly from the widget.
  Future<void> getPromotionalIdeas(String theme) async {
    if (theme.isEmpty) {
      CustomSnackbar.showError('يرجى إدخال موضوع للحصول على أفكار.');
      return;
    }

    try {
      isPromoLoading.value = true;
      promoIdeaResult.value = '';
      await Future.delayed(const Duration(seconds: 2)); // Simulate network call

      promoIdeaResult.value =
      "<ul style='list-style-type: disc; padding-right: 20px;'>"
          "<li>عرض 'طبق اليوم' بخصم 15%.</li>"
          "<li>قائمة تذوق صيفية خاصة.</li>"
          "<li>ساعة سعيدة (Happy Hour) على المشروبات.</li>"
          "</ul>";
    } catch (e) {
      promoIdeaResult.value = 'حدث خطأ أثناء توليد الأفكار.';
    } finally {
      isPromoLoading.value = false;
    }
  }
}