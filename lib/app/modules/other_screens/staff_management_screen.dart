import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_button.dart';

class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We create a dummy RxBool here just for the button's isLoading state.
    // In a real app, this would be in a dedicated controller.
    final isLoading = false.obs;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'إدارة الموظفين',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomButton(
              text: 'إضافة موظف جديد',
              onPressed: () {
                // Logic to add a new staff member will go here.
                // For now, we can show a snackbar.
                Get.snackbar(
                  'قيد التطوير',
                  'سيتم تفعيل هذه الميزة قريباً.',
                  backgroundColor: AppColors.bgTertiary,
                  colorText: AppColors.textPrimary,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              isLoading: isLoading, // Dummy value
            ),
            const SizedBox(height: 24),
            // This is a placeholder for the list of staff members.
            const Expanded(
              child: Center(
                child: Text(
                  'لم يتم إضافة أي موظفين بعد.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
