import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/routes/app_pages.dart';
import 'package:gourmet_pro_app/app/shared/bindings/initial_binding.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_theme.dart';
import 'package:gourmet_pro_app/app/shared/services/localization_service.dart';

void main() async {
  // التأكد من تهيئة Flutter bindings قبل تشغيل أي شيء آخر
  WidgetsFlutterBinding.ensureInitialized();
  // تهيئة خدمة التخزين المحلي
  await GetStorage.init();
  // تحميل ملفات الترجمة
  await LocalizationService.loadTranslations();
  // تشغيل التطبيق
  runApp(const GourmetProApp());
}

class GourmetProApp extends StatelessWidget {
  const GourmetProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Gourmet Pro",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // Multi-language support
      translations: LocalizationService(),
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.fallbackLocale,
    );
  }
}

