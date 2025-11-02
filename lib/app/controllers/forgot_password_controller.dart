import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';

class ForgotPasswordController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final currentStep = 1.obs; // 1: Email, 2: Code, 3: New Password

  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> requestResetCode() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'error'.tr,
        'email_required'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'error'.tr,
        'invalid_email'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiProvider.requestPasswordReset(emailController.text.trim());

      if (response.isOk) {
        currentStep.value = 2;
        Get.snackbar(
          'success'.tr,
          'password_reset_sent'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'error'.tr,
          response.body['message'] ?? 'error_occurred'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'network_error'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyCode() async {
    if (codeController.text.trim().isEmpty) {
      Get.snackbar(
        'error'.tr,
        'code_required'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (codeController.text.trim().length != 6) {
      Get.snackbar(
        'error'.tr,
        'invalid_code'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiProvider.verifyResetCode(
        emailController.text.trim(),
        codeController.text.trim(),
      );

      if (response['valid'] == true) {
        currentStep.value = 3;
        Get.snackbar(
          'success'.tr,
          'code_verified'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'error'.tr,
          'invalid_or_expired_code'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'network_error'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (newPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'error'.tr,
        'password_required'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text.trim().length < 6) {
      Get.snackbar(
        'error'.tr,
        'password_too_short'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text.trim() != confirmPasswordController.text.trim()) {
      Get.snackbar(
        'error'.tr,
        'passwords_dont_match'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiProvider.resetPassword(
        emailController.text.trim(),
        codeController.text.trim(),
        newPasswordController.text.trim(),
      );

      if (response.isOk) {
        Get.snackbar(
          'success'.tr,
          'password_reset_success'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate back to login
        Get.back();
      } else {
        Get.snackbar(
          'error'.tr,
          response.body['message'] ?? 'error_occurred'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'network_error'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }
}
