import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/product_management/product_management_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_button.dart';

import '../../../shared/constants/api_constants.dart';

class AddEditDishScreen extends GetView<ProductManagementController> {
  const AddEditDishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkEditingMode();
    });

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        centerTitle: true,
        title: Obx(
              () => Text(
            controller.isEditMode.value ? 'تعديل طبق' : 'إضافة طبق جديد',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
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
            _buildImageUploader(),
            const SizedBox(height: 24),
            _buildTextField(
              label: 'اسم الطبق (AR)',
              controller: controller.nameArController,
              hint: 'مثال: سلمون مشوي',
            ),
            _buildAiButton(
              label: '✨ ترجمة إلى EN',
              isLoading: controller.isTranslatingName,
              onPressed: controller.translateName,
            ),
            _buildTextField(
              label: 'Dish Name (EN)',
              controller: controller.nameEnController,
              hint: 'e.g., Grilled Salmon',
              readOnly: true,
              backgroundColor: AppColors.bgTertiary,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'الوصف (AR)',
              controller: controller.descriptionArController,
              hint: 'وصف قصير وجذاب للطبق...',
              maxLines: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAiButton(
                  label: '✨ ترجمة إلى EN',
                  isLoading: controller.isTranslatingDescription,
                  onPressed: controller.translateDescription,
                ),
                _buildAiButton(
                  label: '✨ تحسين الوصف',
                  isLoading: controller.isEnhancingDescription,
                  onPressed: controller.enhanceDescription,
                  isPrimary: false,
                ),
              ],
            ),
            _buildTextField(
              label: 'Description (EN)',
              controller: controller.descriptionEnController,
              hint: 'A short and appealing description...',
              readOnly: true,
              maxLines: 3,
              backgroundColor: AppColors.bgTertiary,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: "السعر",
                    controller: controller.priceController,
                    hint: "0.00",
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: "الفئة",
                    controller: controller.categoryController,
                    hint: "طبق رئيسي",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: 'حفظ الطبق',
          onPressed: controller.saveDish,
          isLoading: controller.isSaving,
        ),
      ),
    );
  }

  // ✨ --- تم تحديث هذا الويدجت بالكامل --- ✨
  Widget _buildImageUploader() {
    return Obx(() {
      final pickedImage = controller.pickedImage.value;
      final existingImageUrl = controller.isEditMode.value
          ? (Get.arguments as dynamic).imageUrl
          : null;

      Widget imageWidget;

      if (pickedImage != null) {
        // إذا اختار المستخدم صورة جديدة
        imageWidget = Image.file(pickedImage, fit: BoxFit.cover);
      } else if (existingImageUrl != null) {
        // إذا كان في وضع التعديل وهناك صورة موجودة
        imageWidget = Image.network(
          '${ApiConstants.baseUrl}/$existingImageUrl', // بناء المسار الكامل للصورة
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } else {
        // الحالة الافتراضية (إضافة جديد أو لا توجد صورة)
        imageWidget = _buildPlaceholder();
      }

      return GestureDetector(
        onTap: controller.pickImage,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bgSecondary,
                border: Border.all(color: AppColors.bgTertiary),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imageWidget,
                  // إضافة أيقونة الكاميرا فوق الصورة
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white70,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ويدجت مساعد لعرض المحتوى الافتراضي لمربع الصورة
  Widget _buildPlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_outlined, color: AppColors.textSecondary, size: 48),
        SizedBox(height: 8),
        Text(
          'اختر صورة',
          style: TextStyle(color: AppColors.textSecondary),
        )
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    bool readOnly = false,
    Color backgroundColor = AppColors.bgSecondary,
    TextInputType? keyboardType,
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
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildAiButton({
    required String label,
    required RxBool isLoading,
    required VoidCallback onPressed,
    bool isPrimary = true,
  }) {
    final buttonColor =
    isPrimary ? const Color(0xFF008080) : const Color(0xFF4F46E5);
    final hoverColor =
    isPrimary ? const Color(0xFF006666) : const Color(0xFF4338CA);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Obx(
              () => TextButton(
            onPressed: isLoading.value ? null : onPressed,
            style: TextButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ).copyWith(
              overlayColor: MaterialStateProperty.all(hoverColor),
            ),
            child: isLoading.value
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
