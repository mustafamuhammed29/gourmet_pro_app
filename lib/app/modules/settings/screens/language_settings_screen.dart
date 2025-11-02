import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/shared/services/localization_service.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('change_language'.tr),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLanguageTile('ar', '🇸🇦'),
          const SizedBox(height: 12),
          _buildLanguageTile('en', '🇺🇸'),
          const SizedBox(height: 12),
          _buildLanguageTile('de', '🇩🇪'),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(String langCode, String flag) {
    final isSelected = LocalizationService.getCurrentLanguage() == langCode;

    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Get.theme.colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: Text(
          flag,
          style: const TextStyle(fontSize: 32),
        ),
        title: Text(
          LocalizationService.getLanguageName(langCode),
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Get.theme.colorScheme.primary : null,
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Get.theme.colorScheme.primary,
              )
            : null,
        onTap: () {
          LocalizationService.changeLocale(langCode);
          Get.back();
          Get.snackbar(
            'success'.tr,
            'Language changed successfully',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        },
      ),
    );
  }
}
