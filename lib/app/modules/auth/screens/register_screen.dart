import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/auth/auth_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('تسجيل مطعم جديد'),
        centerTitle: true,
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionTitle("معلومات المالك"),
                _buildTextField(
                  controller: controller.fullNameController,
                  labelText: 'الاسم الكامل للمالك',
                  validator: (value) =>
                  value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                _buildTextField(
                  controller: controller.registerEmailController,
                  labelText: 'البريد الإلكتروني',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value == null || !GetUtils.isEmail(value))
                      ? 'الرجاء إدخال بريد إلكتروني صالح'
                      : null,
                ),
                _buildTextField(
                  controller: controller.phoneNumberController,
                  labelText: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                  value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                Obx(() => _buildTextField(
                  controller: controller.registerPasswordController,
                  labelText: 'كلمة المرور',
                  obscureText: controller.isRegisterPasswordHidden.value,
                  validator: (value) => (value == null || value.length < 6)
                      ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
                      : null,
                  suffixIcon: IconButton(
                    icon: Icon(controller.isRegisterPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: controller.isRegisterPasswordHidden.toggle,
                  ),
                )),
                Obx(() => _buildTextField(
                  controller: controller.confirmPasswordController,
                  labelText: 'تأكيد كلمة المرور',
                  obscureText: controller.isRegisterPasswordHidden.value,
                  validator: (value) {
                    if (value != controller.registerPasswordController.text) {
                      return 'كلمتا المرور غير متطابقتين';
                    }
                    return null;
                  },
                )),
                const SizedBox(height: 24),
                _buildSectionTitle("معلومات المطعم"),
                _buildTextField(
                  controller: controller.restaurantNameController,
                  labelText: 'اسم المطعم',
                  validator: (value) =>
                  value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                _buildTextField(
                  controller: controller.addressController,
                  labelText: 'العنوان',
                  validator: (value) =>
                  value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                _buildTextField(
                  controller: controller.cuisineTypeController,
                  labelText: 'نوع المطبخ (مثال: إيطالي، شرقي)',
                  validator: (value) =>
                  value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("المستندات الرسمية"),
                _buildFileUpload(
                  label: "رخصة البلدية",
                  onTap: controller.pickLicense,
                  fileName: controller.licenseFileName.value,
                  fileObservable: controller.licenseFile,
                ),
                _buildFileUpload(
                  label: "السجل التجاري",
                  onTap: controller.pickRegistry,
                  fileName: controller.registryFileName.value,
                  fileObservable: controller.commercialRegistryFile,
                ),
                const SizedBox(height: 32),
                Obx(
                      () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.registerAndUploadFiles,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                        : const Text('إنشاء حساب',
                        style:
                        TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Get.textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildFileUpload({
    required String label,
    required VoidCallback onTap,
    required String fileName,
    required Rx<File?> fileObservable,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.bgTertiary),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() {
              if (fileObservable.value == null) {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('اختيار ملف',
                        style: TextStyle(color: AppColors.accent)),
                    SizedBox(width: 8),
                    Icon(Icons.attach_file, color: AppColors.textSecondary),
                  ],
                );
              } else {
                return Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileName,
                        style: const TextStyle(color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

