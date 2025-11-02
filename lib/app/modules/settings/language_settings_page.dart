import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/controllers/language_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

class LanguageSettingsPage extends GetView<LanguageController> {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('change_language'.tr),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.supportedLanguages.length,
            itemBuilder: (context, index) {
              final language = controller.supportedLanguages[index];
              final isSelected = controller.currentLocale.value.languageCode == language['code'];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: isSelected ? 4 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        language['flag'],
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  title: Text(
                    language['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.accent : null,
                    ),
                  ),
                  subtitle: Text(
                    language['code'].toString().toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? AppColors.accent.withOpacity(0.7) : Colors.grey,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: AppColors.accent,
                          size: 28,
                        )
                      : const Icon(
                          Icons.circle_outlined,
                          color: Colors.grey,
                          size: 28,
                        ),
                  onTap: () {
                    controller.changeLanguage(language['code']);
                  },
                ),
              );
            },
          )),
    );
  }
}
