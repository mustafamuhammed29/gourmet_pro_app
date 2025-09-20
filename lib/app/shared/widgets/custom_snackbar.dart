import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

/// A helper class for showing custom styled snackbars.
class CustomSnackbar {
  /// Shows an error snackbar with a red accent.
  static void showError(String message) {
    _showSnackbar(
      title: 'خطأ',
      message: message,
      icon: Icons.error_outline,
      color: Colors.redAccent,
    );
  }

  /// Shows a success snackbar with the app's accent color.
  static void showSuccess(String message) {
    _showSnackbar(
      title: 'نجاح',
      message: message,
      icon: Icons.check_circle_outline,
      color: AppColors.accent,
    );
  }

  /// The private base method for displaying the snackbar.
  static void _showSnackbar({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    // Avoids stacking multiple snackbars.
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    Get.rawSnackbar(
      titleText: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      ),
      icon: Icon(icon, color: color, size: 32),
      backgroundColor: AppColors.bgSecondary,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
    );
  }
}
