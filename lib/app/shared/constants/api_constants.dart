import 'dart:io';

// هذا الملف يحتوي على كل الثوابت المتعلقة بالـ API
class ApiConstants {
  // ✨ تحديد الرابط الأساسي تلقائياً بناءً على البيئة
  static String get baseUrl {
    if (Platform.isAndroid) {
      // للمحاكي Android: استخدم 10.0.2.2 للوصول إلى localhost على الجهاز المضيف
      return 'http://10.0.2.2:3000';
    } else if (Platform.isIOS) {
      // لمحاكي iOS: استخدم localhost مباشرة
      return 'http://localhost:3000';
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // لأجهزة Desktop (Windows, macOS, Linux): استخدم localhost
      return 'http://localhost:3000';
    } else {
      // افتراضي: localhost
      return 'http://localhost:3000';
    }
  }

  // المسار الأساسي لملفات التحميل، نحتاجه لعرض الصور من الخادم
  static String get uploadsBaseUrl => '$baseUrl/uploads';
}
