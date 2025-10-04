import 'app_config.dart';

// هذا الملف يحتوي على كل الثوابت المتعلقة بالـ API
class ApiConstants {
  // استخدام التكوين المركزي مع إمكانية التخصيص
  // يمكن تغيير الرابط عبر متغيرات البيئة أو التكوين
  static const String baseUrl = AppConfig.baseUrl;

  // API Endpoints
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String products = '/products';
  static const String restaurants = '/restaurants';
  static const String chat = '/chat';
  static const String ai = '/ai';
}
