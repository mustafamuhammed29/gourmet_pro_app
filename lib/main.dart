import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/routes/app_pages.dart';
import 'package:gourmet_pro_app/app/shared/bindings/initial_binding.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_theme.dart';

void main() async {
  // التأكد من تهيئة Flutter bindings قبل تشغيل أي شيء آخر
  WidgetsFlutterBinding.ensureInitialized();
  // تهيئة خدمة التخزين المحلي
  await GetStorage.init();
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
      // هذا السطر هو الحل لمشكلة "not found"
      // سيقوم بتشغيل InitialBinding قبل بناء أي واجهة
      // مما يضمن أن كل الخدمات العامة جاهزة
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // ضبط اللغة الافتراضية إلى العربية
      locale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),
    );
  }
}

