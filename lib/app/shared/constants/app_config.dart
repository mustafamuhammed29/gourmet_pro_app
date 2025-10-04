class AppConfig {
  // API Configuration
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/',
  );
// App Configuration
  static const String appName = 'Gourmet Pro';
  static const String appVersion = '1.0.0';

  // File Upload Configuration
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];

  // Validation Configuration
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;

  // UI Configuration
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // WhatsApp Configuration
  static const String supportPhoneNumber = '+966000000000';
  static const String supportMessage = 'أهلاً Gourmet Pro، أنا مهتم بفتح مطعم جديد وأود معرفة المزيد عن خدماتكم.';
}
