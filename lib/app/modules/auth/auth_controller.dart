import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';

class AuthController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final _storage = GetStorage();

  // --- General State ---
  final isLoading = false.obs;

  // --- Login Screen State ---
  final loginFormKey = GlobalKey<FormState>();
  late TextEditingController loginEmailController;
  late TextEditingController loginPasswordController;
  final isPasswordHidden = true.obs;

  // --- Register Screen State ---
  final registerFormKey = GlobalKey<FormState>();
  late TextEditingController restaurantNameController;
  late TextEditingController addressController;
  late TextEditingController cuisineTypeController;
  late TextEditingController registerEmailController;
  late TextEditingController phoneNumberController;
  late TextEditingController registerPasswordController;
  late TextEditingController confirmPasswordController;
  final isLoginPasswordHidden = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize login controllers
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();

    // Initialize register controllers
    restaurantNameController = TextEditingController();
    addressController = TextEditingController();
    cuisineTypeController = TextEditingController();
    registerEmailController = TextEditingController();
    phoneNumberController = TextEditingController();
    registerPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    // Dispose login controllers
    loginEmailController.dispose();
    loginPasswordController.dispose();

    // Dispose register controllers
    restaurantNameController.dispose();
    addressController.dispose();
    cuisineTypeController.dispose();
    registerEmailController.dispose();
    phoneNumberController.dispose();
    registerPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // --- Login Logic ---
  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      isLoading(true);
      try {
        final response = await _apiProvider.login(
          loginEmailController.text.trim(),
          loginPasswordController.text,
        );

        if (response.isOk && response.body['access_token'] != null) {
          await _storage.write('token', response.body['access_token']);
          Get.offAllNamed(Routes.mainWrapper);
        } else {
          Get.snackbar(
            'خطأ في تسجيل الدخول',
            response.body['message'] ??
                'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'خطأ',
          'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading(false);
      }
    }
  }

  // --- Register Logic ---
  Future<void> register() async {
    if (registerFormKey.currentState!.validate()) {
      isLoading(true);
      try {
        final data = {
          "restaurantName": restaurantNameController.text.trim(),
          "address": addressController.text.trim(),
          "cuisineType": cuisineTypeController.text.trim(),
          "email": registerEmailController.text.trim(),
          "phoneNumber": phoneNumberController.text.trim(),
          "password": registerPasswordController.text,
        };

        final response = await _apiProvider.register(data);

        if (response.isOk) {
          Get.offAllNamed(Routes.pendingApproval);
        } else {
          Get.snackbar(
            'خطأ في التسجيل',
            response.body['message'] ?? 'الرجاء التحقق من البيانات المدخلة.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'خطأ',
          'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading(false);
      }
    }
  }
}
