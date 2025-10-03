import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gourmet_pro_app/app/data/models/user_model.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';

class AuthController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final _storage = GetStorage();

  final isLoading = false.obs;
  var user = Rx<UserModel?>(null);

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  late TextEditingController loginEmailController;
  late TextEditingController loginPasswordController;
  final isPasswordHidden = true.obs;

  late TextEditingController fullNameController;
  late TextEditingController restaurantNameController;
  late TextEditingController addressController;
  late TextEditingController cuisineTypeController;
  late TextEditingController registerEmailController;
  late TextEditingController phoneNumberController;
  late TextEditingController registerPasswordController;
  late TextEditingController confirmPasswordController;
  final isRegisterPasswordHidden = true.obs;

  final Rx<File?> licenseFile = Rx<File?>(null);
  final Rx<File?> commercialRegistryFile = Rx<File?>(null);
  final licenseFileName = ''.obs;
  final registryFileName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _checkToken();
  }

  void _initializeControllers() {
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();
    fullNameController = TextEditingController();
    restaurantNameController = TextEditingController();
    addressController = TextEditingController();
    cuisineTypeController = TextEditingController();
    registerEmailController = TextEditingController();
    phoneNumberController = TextEditingController();
    registerPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void _checkToken() {
    final token = _storage.read('token');
    if (token != null) {
      // تأخير الانتقال إلى ما بعد الإطار الأول لتجنب خطأ "contextless navigation"
      Future.delayed(Duration.zero, () {
        Get.offAllNamed(Routes.mainWrapper);
      });
    }
  }

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (loginFormKey.currentState?.validate() ?? false) {
      isLoading(true);
      try {
        final response = await _apiProvider.login(
          loginEmailController.text.trim(),
          loginPasswordController.text,
        );
        if (response.isOk && response.body != null) {
          final token = response.body['access_token'];
          final status = response.body['status'];
          if (status == 'approved' && token != null) {
            await _storage.write('token', token);
            Get.offAllNamed(Routes.mainWrapper);
          } else if (status == 'pending') {
            Get.toNamed(Routes.pendingApproval);
          } else {
            CustomSnackbar.showError(
                response.body['message'] ?? 'تم رفض حسابك.');
          }
        } else {
          CustomSnackbar.showError(
            response.body?['message'] ??
                'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
          );
        }
      } catch (e) {
        CustomSnackbar.showError('حدث خطأ غير متوقع: ${e.toString()}');
      } finally {
        isLoading(false);
      }
    }
  }

  Future<void> registerAndUploadFiles() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (registerFormKey.currentState?.validate() ?? false) {
      if (licenseFile.value == null || commercialRegistryFile.value == null) {
        CustomSnackbar.showError('الرجاء رفع كلا المستندين المطلوبين.');
        return;
      }
      isLoading(true);
      try {
        final data = {
          'fullName': fullNameController.text.trim(),
          'email': registerEmailController.text.trim(),
          'password': registerPasswordController.text,
          'phoneNumber': phoneNumberController.text.trim(),
          'restaurantName': restaurantNameController.text.trim(),
          'cuisineType': cuisineTypeController.text.trim(),
          'address': addressController.text.trim(),
        };

        // --- تم التعديل هنا ---
        final response = await _apiProvider.registerAndUpload(
          data: data,
          licenseFile: licenseFile.value!,
          registryFile: commercialRegistryFile.value!,
        );

        // --- وتم التعديل هنا ---
        if (response.statusCode == 201) {
          CustomSnackbar.showSuccess(
              'تم التسجيل بنجاح! طلبك الآن قيد المراجعة.');
          Get.toNamed(Routes.pendingApproval);
        } else {
          final decodedBody = jsonDecode(response.body);
          CustomSnackbar.showError(
              decodedBody['message'] ?? 'فشل التسجيل. حاول مرة أخرى.');
        }
      } catch (e) {
        CustomSnackbar.showError('حدث خطأ غير متوقع: ${e.toString()}');
      } finally {
        isLoading(false);
      }
    }
  }

  void logout() async {
    await _storage.remove('token');
    Get.offAllNamed(Routes.login);
  }

  Future<void> pickLicense() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      licenseFile.value = File(result.files.single.path!);
      licenseFileName.value = result.files.single.name;
    }
  }

  Future<void> pickRegistry() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      commercialRegistryFile.value = File(result.files.single.path!);
      registryFileName.value = result.files.single.name;
    }
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _disposeControllers() {
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
  }
}

