import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/profile/profile_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_snackbar.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'تعديل الملف الشخصي',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // NEW: Added image editing functionality (UI only)
            _buildLogoEditor(),
            const SizedBox(height: 32),
            _buildTextField(
              label: 'اسم المطعم',
              controller: controller.restaurantNameController,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'نبذة تعريفية (تظهر تحت الاسم)',
              controller: controller.bioController,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'قصتنا (تظهر في بطاقة منفصلة)',
              controller: controller.storyController,
              maxLines: 5,
            ),
            const SizedBox(height: 32),
            // The Obx is no longer needed here as the button handles its own state
            CustomButton(
              text: 'حفظ التغييرات',
              onPressed: () => controller.saveProfileChanges(),
              // FIXED: Pass the RxBool directly, not its .value
              isLoading: controller.isSaving,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLogoEditor() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.bgSecondary,
            child: ClipOval(
              child: Image.network(
                controller.logoUrl.value,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.storefront,
                    color: AppColors.textSecondary,
                    size: 50,
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: -5,
            right: -5,
            child: GestureDetector(
              onTap: () {
                // TODO: Add logic to pick image from gallery/camera
                CustomSnackbar.showInfo('سيتم تفعيل ميزة تغيير الصورة قريباً.');
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.bgSecondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.bgTertiary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.bgTertiary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

