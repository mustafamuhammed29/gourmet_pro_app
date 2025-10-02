import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';

class AuthController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final _storage = GetStorage();

  final isLoading = false.obs;

  // ... (Login properties)
  final loginFormKey = GlobalKey<FormState>();
  late TextEditingController loginEmailController;
  late TextEditingController loginPasswordController;
  final isPasswordHidden = true.obs;

  // --- Register ---
  final registerFormKey = GlobalKey<FormState>();
  late TextEditingController fullNameController; //  <-- ١. إضافة المتحكم الجديد
  late TextEditingController restaurantNameController;
  late TextEditingController addressController;
  late TextEditingController cuisineTypeController;
  late TextEditingController registerEmailController;
  late TextEditingController phoneNumberController;
  late TextEditingController registerPasswordController;
  late TextEditingController confirmPasswordController;
  final isLoginPasswordHidden = true.obs;

  // --- File Upload ---
  final Rx<File?> licenseFile = Rx<File?>(null);
  final Rx<File?> registryFile = Rx<File?>(null);
  String get licenseFileName => licenseFile.value?.path.split('/').last ?? '';
  String get registryFileName =>
      registryFile.value?.path.split('/').last ?? '';

  @override
  void onInit() {
    super.onInit();
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();
    fullNameController = TextEditingController(); //  <-- ٢. تهيئة المتحكم
    restaurantNameController = TextEditingController();
    addressController = TextEditingController();
    cuisineTypeController = TextEditingController();
    registerEmailController = TextEditingController();
    phoneNumberController = TextEditingController();
    registerPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  // ... (File picking logic)
  Future<File?> _pickSingleFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<void> pickLicense() async {
    licenseFile.value = await _pickSingleFile();
  }

  Future<void> pickRegistry() async {
    registryFile.value = await _pickSingleFile();
  }


  Future<void> register() async {
    if (registerFormKey.currentState!.validate()) {
      if (licenseFile.value == null || registryFile.value == null) {
        CustomSnackbar.showError('يرجى رفع ملفي الرخصة والسجل التجاري.');
        return;
      }
      isLoading(true);
      try {
        final data = {
          "fullName": fullNameController.text.trim(), //  <-- ٣. إرسال الاسم الكامل
          "restaurantName": restaurantNameController.text.trim(),
          "address": addressController.text.trim(),
          "cuisineType": cuisineTypeController.text.trim(),
          "email": registerEmailController.text.trim(),
          "phoneNumber": phoneNumberController.text.trim(),
          "password": registerPasswordController.text,
        };
        final files = [licenseFile.value!, registryFile.value!];

        final response = await _apiProvider.registerAndUpload(data, files);
        final responseBody = json.decode(response.body);

        if (response.statusCode == 201) {
          Get.offAllNamed(Routes.pendingApproval);
          CustomSnackbar.showSuccess(
              responseBody['message'] ?? 'تم إرسال طلبك بنجاح!');
        } else {
          CustomSnackbar.showError(
              responseBody['message'] ?? 'الرجاء التحقق من البيانات المدخلة.');
        }
      } catch (e) {
        CustomSnackbar.showError('حدث خطأ غير متوقع: ${e.toString()}');
      } finally {
        isLoading(false);
      }
    }
  }

  // ... (Login logic and onClose)
  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      isLoading(true);
      try {
        final response = await _apiProvider.login(
          loginEmailController.text.trim(),
          loginPasswordController.text,
        );
        if (response.isOk && response.body['access_token'] != null) {
          await _storage.write('authToken', response.body['access_token']);
          Get.offAllNamed(Routes.mainWrapper);
        } else {
          CustomSnackbar.showError(
            response.body['message'] ??
                'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
          );
        }
      } catch (e) {
        CustomSnackbar.showError(
          'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
        );
      } finally {
        isLoading(false);
      }
    }
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    fullNameController.dispose();
    restaurantNameController.dispose();
    addressController.dispose();
    cuisineTypeController.dispose();
    registerEmailController.dispose();
    phoneNumberController.dispose();
    registerPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

