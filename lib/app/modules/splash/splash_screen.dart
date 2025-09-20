import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/splash/splash_controller.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_button.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = false.obs;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fallback solid background color
          Container(color: AppColors.bgPrimary),

          // Network image with loading and error handling
          Image.network(
            'https://placehold.co/400x800/222/111?text=Gourmet+BG',
            fit: BoxFit.cover,
            // Show a loading indicator while the image is being fetched
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator(color: AppColors.accent));
            },
            // IMPORTANT: This prevents the app from crashing if the image fails to load
            errorBuilder: (context, error, stackTrace) {
              // You can return a placeholder widget here, but for a background,
              // an empty container is fine as the solid color will show through.
              return const SizedBox.shrink();
            },
          ),

          // Dark overlay for better text readability
          Container(
            color: AppColors.bgPrimary.withOpacity(0.85),
          ),

          // Main content of the screen
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.ramen_dining, color: AppColors.accent, size: 80),
                        const SizedBox(height: 16),
                        const Text(
                          'Gourmet Pro',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'نرتقي بالتميز في الطهي',
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.8),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    text: 'تسجيل الدخول',
                    onPressed: () => Get.toNamed(Routes.login),
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'تسجيل مطعمك',
                    onPressed: () => Get.toNamed(Routes.register),
                    isLoading: isLoading,
                    isPrimary: false,
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    icon: const Icon(Icons.support_agent, color: AppColors.accent),
                    label: const Text(
                      'تفكر بفتح مطعم؟ تواصل معنا',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    onPressed: () => controller.launchWhatsApp(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'بالاستمرار، أنت توافق على الشروط والأحكام وسياسة الخصوصية.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

