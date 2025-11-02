import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/routes/app_pages.dart';
import 'package:gourmet_pro_app/app/shared/bindings/initial_binding.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_theme.dart';
import 'package:gourmet_pro_app/app/translations/app_translations.dart';
import 'package:gourmet_pro_app/app/controllers/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  // Initialize Language Controller
  Get.put(LanguageController());
  
  runApp(const GourmetProApp());
}

class GourmetProApp extends StatelessWidget {
  const GourmetProApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    
    return GetMaterialApp(
      title: "Gourmet Pro",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // Multi-language support
      translations: AppTranslations(),
      locale: languageController.currentLocale.value,
      fallbackLocale: const Locale('ar'),
    );
  }
}

