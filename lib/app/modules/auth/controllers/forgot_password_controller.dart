import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final ApiProvider apiProvider = Get.find();

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> requestPasswordReset() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'error'.tr,
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      await apiProvider.requestPasswordReset(emailController.text.trim());
      
      Get.snackbar(
        'success'.tr,
        'Verification code sent to your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.toNamed(Routes.VERIFY_CODE);
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyCode() async {
    if (codeController.text.trim().length != 6) {
      Get.snackbar(
        'error'.tr,
        'Please enter a valid 6-digit code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await apiProvider.verifyResetCode(
        emailController.text.trim(),
        codeController.text.trim(),
      );

      if (response['valid'] == true) {
        Get.snackbar(
          'success'.tr,
          'Code verified successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.toNamed(Routes.RESET_PASSWORD);
      } else {
        Get.snackbar(
          'error'.tr,
          'Invalid or expired code',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (newPasswordController.text.trim().length < 6) {
      Get.snackbar(
        'error'.tr,
        'password_too_short'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'error'.tr,
        'passwords_dont_match'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      await apiProvider.resetPassword(
        emailController.text.trim(),
        codeController.text.trim(),
        newPasswordController.text.trim(),
      );

      Get.snackbar(
        'success'.tr,
        'Password reset successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to login
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
