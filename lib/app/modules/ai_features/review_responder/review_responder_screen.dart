import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/ai_features/review_responder/review_responder_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

class ReviewResponderScreen extends GetView<ReviewResponderController> {
  const ReviewResponderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مساعد الرد على التقييمات'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLabel('الصق تقييم الزبون هنا:'),
            _buildReviewInputField(),
            const SizedBox(height: 24),
            _buildGenerateButton(),
            const SizedBox(height: 24),
            _buildLabel('الرد المقترح:'),
            _buildResponseOutputField(),
          ],
        ),
      ),
      bottomNavigationBar: _buildCopyButton(),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildReviewInputField() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bgTertiary),
      ),
      child: TextField(
        controller: controller.reviewInputController,
        textAlign: TextAlign.right,
        maxLines: 5,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: const InputDecoration(
          hintText: "مثال: 'كان الطعام ممتازاً والخدمة سريعة...'",
          hintStyle: TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isGenerating.value
            ? null
            : () => controller.generateReviewResponse(),
        icon: controller.isGenerating.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : const Icon(Icons.auto_awesome, size: 20),
        label: const Text('✨ إنشاء رد'),
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
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(16),
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: SingleChildScrollView(
          child: SelectableText(
            controller.aiResponse.value.isEmpty
                ? 'سيظهر الرد المقترح هنا...'
                : controller.aiResponse.value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: controller.aiResponse.value.isEmpty
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
              height: 1.5,
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
              ? null // تعطيل الزر إذا لم يكن هناك نص
              : () {
            Clipboard.setData(ClipboardData(text: controller.aiResponse.value));
            Get.snackbar(
              'تم النسخ',
              'تم نسخ الرد بنجاح إلى الحافظة.',
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
            'نسخ الرد',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
