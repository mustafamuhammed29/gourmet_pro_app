import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/ai_features/social_post_generator/social_post_generator_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

class SocialPostGeneratorScreen extends GetView<SocialPostGeneratorController> {
  const SocialPostGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء منشور ترويجي'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDishInfoCard(),
            const SizedBox(height: 24),
            _buildGenerateButton(),
            const SizedBox(height: 16),
            _buildResponseOutputField(),
          ],
        ),
      ),
      bottomNavigationBar: _buildCopyButton(),
    );
  }

  Widget _buildDishInfoCard() {
    return Obx(() {
      if (controller.product.value == null) {
        return const Center(child: Text('جاري تحميل بيانات الطبق...'));
      }
      final product = controller.product.value!;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageUrl ?? 'https://placehold.co/100x100/333/FFF?text=Dish',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.restaurant_menu, size: 80),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildGenerateButton() {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isGenerating.value
            ? null
            : () => controller.generateSocialPost(),
        icon: controller.isGenerating.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : const Icon(Icons.auto_awesome, size: 20),
        label: const Text('✨ إنشاء منشور'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F46E5), // Indigo color
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildResponseOutputField() {
    return Obx(
          () => Container(
        padding: const EdgeInsets.all(16),
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: SingleChildScrollView(
          child: SelectableText(
            controller.aiResponse.value.isEmpty
                ? 'سيظهر محتوى المنشور هنا...'
                : controller.aiResponse.value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: controller.aiResponse.value.isEmpty
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCopyButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Obx(
            () => ElevatedButton(
          onPressed: controller.aiResponse.value.isEmpty
              ? null
              : () {
            Clipboard.setData(ClipboardData(text: controller.aiResponse.value));
            Get.snackbar(
              'تم النسخ',
              'تم نسخ المنشور بنجاح إلى الحافظة.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.shade700,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'نسخ النص',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
