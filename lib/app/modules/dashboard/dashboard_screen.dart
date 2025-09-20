import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/ai_features/promo_generator/promo_generator_widget.dart';
import 'package:gourmet_pro_app/app/modules/dashboard/dashboard_controller.dart';

import '../../routes/app_routes.dart';
import '../../shared/theme/app_colors.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.textPrimary),
          onPressed: () => controller.openMainMenu(),
        ),
        title: Obx(() => Text(
          controller.restaurantName.value,
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        )),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined,
                    color: AppColors.textPrimary),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.bgPrimary, width: 2),
                    ),
                    constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                  ),
                )
              ],
            ),
            onPressed: () => Get.toNamed(Routes.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 24),
            Text('إجراءات سريعة', style: Get.textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildQuickActions(),
            const SizedBox(height: 24),
            const PromoGeneratorWidget(),
            const SizedBox(height: 24),
            Text('آخر الإشعارات', style: Get.textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildNotificationsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return AspectRatio(
      aspectRatio: 16 / 8,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                "https://placehold.co/600x400/000000/FFFFFF?text=Restaurant+Banner",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.bgSecondary,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
          const Positioned(
            bottom: 16,
            right: 16,
            child: Text(
              'مرحباً بعودتك!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _QuickActionButton(
          icon: Icons.menu_book,
          label: 'إدارة القائمة',
          onTap: () => Get.toNamed(Routes.manageMenu),
        ),
        // FIX: This button now navigates to the services screen.
        _QuickActionButton(
          icon: Icons.design_services,
          label: 'خدماتنا',
          onTap: () => Get.toNamed(Routes.services),
        ),
        _QuickActionButton(
          icon: Icons.analytics,
          label: 'التحليلات',
          onTap: () => Get.toNamed(Routes.analytics),
        ),
        _QuickActionButton(
          icon: Icons.edit_note,
          label: 'تعديل الملف',
          onTap: () => Get.toNamed(Routes.editProfile),
        ),
      ],
    );
  }

  Widget _buildNotificationsList() {
    final notifications = [
      'نصيحة: قم بتحديث صور أطباقك لزيادة التفاعل.',
      'تمت الموافقة على طلبك لخدمة التسويق.',
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.accent),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  notifications[index],
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: AppColors.accent, size: 32),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

