import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String _languageKey = 'selected_language';
  
  final Rx<Locale> currentLocale = const Locale('ar').obs;
  
  final List<Map<String, dynamic>> supportedLanguages = [
    {
      'name': 'العربية',
      'code': 'ar',
      'flag': '🇸🇦',
    },
    {
      'name': 'English',
      'code': 'en',
      'flag': '🇬🇧',
    },
    {
      'name': 'Deutsch',
      'code': 'de',
      'flag': '🇩🇪',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey) ?? 'ar';
    currentLocale.value = Locale(savedLanguage);
    Get.updateLocale(currentLocale.value);
  }

  Future<void> changeLanguage(String languageCode) async {
    currentLocale.value = Locale(languageCode);
    Get.updateLocale(currentLocale.value);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    
    Get.snackbar(
      'success'.tr,
      'language_changed_successfully'.tr,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String getCurrentLanguageName() {
    final language = supportedLanguages.firstWhere(
      (lang) => lang['code'] == currentLocale.value.languageCode,
      orElse: () => supportedLanguages[0],
    );
    return language['name'];
  }

  String getCurrentLanguageFlag() {
    final language = supportedLanguages.firstWhere(
      (lang) => lang['code'] == currentLocale.value.languageCode,
      orElse: () => supportedLanguages[0],
    );
    return language['flag'];
  }
}
