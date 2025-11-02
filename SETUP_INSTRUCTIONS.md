# Gourmet Pro App - Setup Instructions

## إذا واجهت أخطاء compilation

### الخطوة 1: حذف Cache
```bash
cd gourmet_pro_app
rm -rf .dart_tool build .flutter-plugins .flutter-plugins-dependencies .packages
```

### الخطوة 2: تثبيت المكتبات
```bash
flutter pub get
```

### الخطوة 3: إعادة تشغيل IDE
- **VS Code**: Ctrl+Shift+P → "Dart: Restart Analysis Server"
- **Android Studio**: File → Invalidate Caches / Restart

### الخطوة 4: Clean Build
```bash
flutter clean
flutter pub get
```

## الميزات الجديدة المضافة

### 1. دعم متعدد اللغات (i18n)
- العربية (افتراضي)
- الإنجليزية
- الألمانية

**الاستخدام:**
```dart
Text('welcome'.tr)  // سيظهر "مرحباً" بالعربية
```

**تغيير اللغة:**
- من Settings → Language Settings
- أو برمجياً:
```dart
Get.find<LanguageController>().changeLanguage('en');
```

### 2. نظام استعادة كلمة المرور
- طلب رمز التحقق عبر البريد الإلكتروني
- التحقق من الرمز (6 أرقام)
- إعادة تعيين كلمة المرور

**الوصول:**
- من صفحة Login → "نسيت كلمة المرور؟"
- أو برمجياً: `Get.toNamed(Routes.forgotPassword)`

### 3. الملفات المهمة

**Controllers:**
- `lib/app/controllers/forgot_password_controller.dart`
- `lib/app/controllers/language_controller.dart`

**Translations:**
- `lib/app/translations/ar.dart`
- `lib/app/translations/en.dart`
- `lib/app/translations/de.dart`

**Pages:**
- `lib/app/modules/auth/forgot_password_page.dart`
- `lib/app/modules/settings/language_settings_page.dart`

**Routes:**
- `lib/app/routes/app_routes.dart` - جميع الـ routes معرفة هنا
- `lib/app/routes/app_pages.dart` - جميع الصفحات مسجلة هنا

## ملاحظات مهمة

1. **Backend URL**: تأكد من تحديث `BACKEND_URL` في `lib/app/shared/constants/api_constants.dart`

2. **Email Service**: نظام password reset يحتاج إلى SMTP في Backend

3. **الترجمات**: لإضافة ترجمات جديدة، أضفها في ملفات `lib/app/translations/*.dart`

## الأخطاء الشائعة وحلولها

### خطأ: "The getter 'VERIFY_CODE' isn't defined"
**السبب**: Cache قديم في IDE
**الحل**: اتبع خطوات حذف Cache أعلاه

### خطأ: "Undefined name 'GlobalMaterialLocalizations'"
**السبب**: تم إزالة هذا الـ import لأن GetX يوفر i18n مدمج
**الحل**: تأكد من استخدام أحدث نسخة من الكود

### خطأ: "The getter 'primary' isn't defined for 'AppColors'"
**السبب**: AppColors يستخدم `bgPrimary` وليس `primary`
**الحل**: استخدم `AppColors.bgPrimary` بدلاً من `AppColors.primary`

## التشغيل

```bash
# للتطوير
flutter run

# للبناء (Android)
flutter build apk --release

# للبناء (iOS)
flutter build ios --release
```

## المساعدة

إذا واجهت أي مشاكل:
1. تأكد من حذف جميع ملفات الـ cache
2. تأكد من تشغيل `flutter pub get`
3. أعد تشغيل IDE
4. تحقق من أن جميع الملفات محدثة من GitHub
