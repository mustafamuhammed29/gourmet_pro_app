import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/profile/profile_controller.dart';
import '../../routes/app_routes.dart';
import '../../shared/theme/app_colors.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We can safely find the ProfileController as it's loaded with MainWrapper
    final ProfileController profileController = Get.find();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary.withOpacity(0.95),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'القائمة',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textPrimary,
                      size: 30,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildMenuItem(
                icon: Icons.person_outline,
                text: 'الملف الشخصي',
                onTap: () {
                  Get.back(); // Close the menu first
                  Get.toNamed(Routes.profile);
                },
              ),
              _buildMenuItem(
                icon: Icons.group_outlined,
                text: 'إدارة الموظفين',
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.staffManagement);
                },
              ),
              _buildMenuItem(
                icon: Icons.rate_review_outlined,
                text: 'الرد على التقييمات',
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.reviewResponder);
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => profileController.logout(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 28),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
