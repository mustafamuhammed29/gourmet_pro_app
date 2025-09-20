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
                _buildTextField(
                  controller: controller.restaurantNameController,
                  labelText: 'اسم المطعم',
                  validator: (value) =>
                  value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                _buildTextField(
                  controller: controller.addressController,
                  labelText: 'عنوان المطعم',
                  validator: (value) =>
                  value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                _buildTextField(
                  controller: controller.cuisineTypeController,
                  labelText: 'نوع المطبخ (مثال: إيطالي, آسيوي)',
                  validator: (value) =>
                  value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                _buildTextField(
                  controller: controller.registerEmailController,
                  labelText: 'البريد الإلكتروني',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => !GetUtils.isEmail(value!)
                      ? 'الرجاء إدخال بريد إلكتروني صحيح'
                      : null,
                ),
                _buildTextField(
                  controller: controller.phoneNumberController,
                  labelText: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                  validator: (value) => !GetUtils.isPhoneNumber(value!)
                      ? 'الرجاء إدخال رقم هاتف صحيح'
                      : null,
                ),
                Obx(
                      () => _buildTextField(
                    controller: controller.registerPasswordController,
                    labelText: 'كلمة المرور',
                    obscureText: controller.isLoginPasswordHidden.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isLoginPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: controller.isLoginPasswordHidden.toggle,
                    ),
                    validator: (value) => value!.length < 6
                        ? 'يجب أن تكون كلمة المرور 6 أحرف على الأقل'
                        : null,
                  ),
                ),
                _buildTextField(
                  controller: controller.confirmPasswordController,
                  labelText: 'تأكيد كلمة المرور',
                  obscureText: true,
                  validator: (value) => value !=
                      controller.registerPasswordController.text
                      ? 'كلمتا المرور غير متطابقتين'
                      : null,
                ),
                const SizedBox(height: 24),
                _buildDocumentUploadSection(),
                const SizedBox(height: 24),
                Obx(
                      () => SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.register(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'إرسال الطلب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'سيتم مراجعة طلبك من قبل الإدارة قبل الموافقة عليه.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: suffixIcon,
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildDocumentUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'رفع المستندات',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.bgTertiary, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_upload_outlined,
                    color: AppColors.textSecondary, size: 40),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    // TODO: Implement file picking logic
                    Get.snackbar(
                      'قيد الإنشاء',
                      'سيتم تفعيل ميزة رفع الملفات قريباً.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: const Text('اختر ملف (ترخيص، سجل تجاري)',
                      style: TextStyle(color: AppColors.accent)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

