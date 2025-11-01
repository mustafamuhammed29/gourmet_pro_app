import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/settings/settings_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ملفي',
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
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // معلومات المستخدم
              _SectionTitle(title: 'معلومات الحساب'),
              _InfoCard(
                icon: Icons.restaurant,
                title: 'اسم المطعم',
                value: controller.restaurantName.value.isEmpty
                    ? 'جاري التحميل...'
                    : controller.restaurantName.value,
              ),
              _InfoCard(
                icon: Icons.email,
                title: 'البريد الإلكتروني',
                value: controller.email.value.isEmpty
                    ? 'جاري التحميل...'
                    : controller.email.value,
              ),

              const SizedBox(height: 24),

              // إعدادات التطبيق
              _SectionTitle(title: 'إعدادات التطبيق'),
              _SettingCard(
                icon: Icons.language,
                title: 'اللغة',
                value: controller.currentLanguage.value,
                onTap: () => _showLanguageDialog(controller),
              ),
              _InfoCard(
                icon: Icons.info_outline,
                title: 'إصدار التطبيق',
                value: controller.appVersion.value,
              ),
              _InfoCard(
                icon: Icons.access_time,
                title: 'آخر دخول',
                value: controller.formattedLastLogin,
              ),

              const SizedBox(height: 24),

              // الموقع
              _SectionTitle(title: 'الموقع'),
              _InfoCard(
                icon: Icons.location_on,
                title: 'الموقع الحالي',
                value: controller.formattedLocation,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: controller.isUpdatingLocation.value
                    ? null
                    : () => controller.updateLocation(),
                icon: controller.isUpdatingLocation.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  controller.isUpdatingLocation.value
                      ? 'جاري التحديث...'
                      : 'تحديث الموقع',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void _showLanguageDialog(SettingsController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        title: const Text(
          'اختر اللغة',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              language: 'العربية',
              isSelected: controller.currentLanguage.value == 'العربية',
              onTap: () {
                controller.changeLanguage('العربية');
                Get.back();
              },
            ),
            const SizedBox(height: 12),
            _LanguageOption(
              language: 'English',
              isSelected: controller.currentLanguage.value == 'English',
              onTap: () {
                controller.changeLanguage('English');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withOpacity(0.2) : AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              language,
              style: TextStyle(
                color: isSelected ? AppColors.accent : AppColors.textPrimary,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
