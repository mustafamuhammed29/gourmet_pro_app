import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

/// A utility class for showing styled snackbars across the app.
class CustomSnackbar {
  /// Shows a red-themed snackbar for error messages.
  static void showError(String message) {
    if (Get.isSnackbarOpen) return;
    Get.snackbar(
      'خطأ',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.error_outline, color: Colors.white),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }

  /// Shows a green-themed snackbar for success messages.
  static void showSuccess(String message) {
    if (Get.isSnackbarOpen) return;
    Get.snackbar(
      'نجاح',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }

  /// Shows a neutral-themed snackbar for informational messages.
  static void showInfo(String message) {
    if (Get.isSnackbarOpen) return;
    Get.snackbar(
      'معلومة',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.bgTertiary.withOpacity(0.95),
      colorText: AppColors.textPrimary,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.info_outline, color: AppColors.accent),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }
}

