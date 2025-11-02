import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationService extends Translations {
  static final locale = _getLocaleFromLanguage();
  static final fallbackLocale = const Locale('en', 'US');
  static final langCodes = ['ar', 'en', 'de'];
  static final locales = [
    const Locale('ar', 'SA'),
    const Locale('en', 'US'),
    const Locale('de', 'DE'),
  ];

  static final Map<String, Map<String, String>> _translations = {};

  static Future<void> loadTranslations() async {
    for (String lang in langCodes) {
      String jsonString = await rootBundle.loadString(
        'lib/app/shared/localization/$lang.json',
      );
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _translations['${lang}_${lang.toUpperCase()}'] =
          jsonMap.map((key, value) => MapEntry(key, value.toString()));
    }
  }

  @override
  Map<String, Map<String, String>> get keys => _translations;

  static Locale _getLocaleFromLanguage() {
    final storage = GetStorage();
    String? langCode = storage.read('language');
    
    if (langCode == null) {
      // Try to get device locale
      String deviceLang = Get.deviceLocale?.languageCode ?? 'en';
      if (langCodes.contains(deviceLang)) {
        langCode = deviceLang;
      } else {
        langCode = 'en';
      }
      storage.write('language', langCode);
    }

    switch (langCode) {
      case 'ar':
        return const Locale('ar', 'SA');
      case 'de':
        return const Locale('de', 'DE');
      default:
        return const Locale('en', 'US');
    }
  }

  static void changeLocale(String langCode) {
    final storage = GetStorage();
    storage.write('language', langCode);

    Locale locale;
    switch (langCode) {
      case 'ar':
        locale = const Locale('ar', 'SA');
        break;
      case 'de':
        locale = const Locale('de', 'DE');
        break;
      default:
        locale = const Locale('en', 'US');
    }

    Get.updateLocale(locale);
  }

  static String getCurrentLanguage() {
    final storage = GetStorage();
    return storage.read('language') ?? 'en';
  }

  static String getLanguageName(String langCode) {
    switch (langCode) {
      case 'ar':
        return 'العربية';
      case 'de':
        return 'Deutsch';
      default:
        return 'English';
    }
  }
}
