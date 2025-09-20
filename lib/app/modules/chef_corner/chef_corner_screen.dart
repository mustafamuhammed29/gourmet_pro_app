import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart'; // تم تصحيح هذا السطر
import 'package:gourmet_pro_app/app/modules/chef_corner/chef_corner_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_button.dart';

class ChefCornerScreen extends GetView<ChefCornerController> {
  const ChefCornerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ركن الشيف'),
        centerTitle: true,
        backgroundColor: AppColors.bgPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAiChefAssistant(),
            const SizedBox(height: 32),
            const Text(
              'طلباتي الحالية',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 16),
            Obx(
                  () => ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.myRequests.length,
                itemBuilder: (context, index) {
                  final request = controller.myRequests[index];
                  return _buildRequestCard(request);
                },
                separatorBuilder: (context, index) => const SizedBox(height: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiChefAssistant() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2A72), Color(0xFF009FFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            '✨ مساعد الشيف الذكي',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'أدخل مكوناً أساسياً واحصل على فكرة طبق مبتكرة.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.ingredientController,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'مثال: دجاج، ليمون',
              filled: true,
              fillColor: Colors.black.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            onPressed: () => controller.getDishIdea(),
            text: '✨ الحصول على فكرة طبق',
            isLoading: controller.isLoading,
          ),
          const SizedBox(height: 16),
          Obx(
                () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: controller.aiDishIdea.isNotEmpty
                  ? const EdgeInsets.all(12)
                  : EdgeInsets.zero,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: controller.aiDishIdea.isNotEmpty
                  ? HtmlWidget(
                controller.aiDishIdea.value,
                textStyle: const TextStyle(color: AppColors.textPrimary),
              )
                  : const SizedBox(height: 60),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRequestCard(ChefRequest request) {
    Color statusColor;
    String statusText = request.status;

    switch (statusText) {
      case 'قيد المراجعة':
        statusColor = Colors.yellow.shade700;
        break;
      case 'الوصفة مقترحة':
        statusColor = Colors.green.shade500;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            request.dishName,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

