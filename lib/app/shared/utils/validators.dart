import 'package:gourmet_pro_app/app/shared/constants/app_config.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    if (value.length < AppConfig.minPasswordLength) {
      return 'كلمة المرور يجب أن تكون ${AppConfig.minPasswordLength} أحرف على الأقل';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }

    if (value != password) {
      return 'كلمات المرور غير متطابقة';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value, {String fieldName = 'الاسم'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }

    if (value.length > AppConfig.maxNameLength) {
      return '$fieldName يجب أن يكون أقل من ${AppConfig.maxNameLength} حرف';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }

    // Remove spaces and special characters
    final cleanPhone = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Check if it's a valid Saudi phone number format
    final phoneRegex = RegExp(r'^(\+966|966|0)?[5][0-9]{8}$');
    if (!phoneRegex.hasMatch(cleanPhone)) {
      return 'رقم الهاتف غير صالح (يجب أن يبدأ بـ 05)';
    }

    return null;
  }

  // Price validation
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'السعر مطلوب';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'السعر يجب أن يكون رقم صالح';
    }

    if (price <= 0) {
      return 'السعر يجب أن يكون أكبر من صفر';
    }

    if (price > 9999999.99) {
      return 'السعر كبير جداً';
    }

    return null;
  }

  // Description validation
  static String? validateDescription(String? value, {bool required = true}) {
    if (required && (value == null || value.isEmpty)) {
      return 'الوصف مطلوب';
    }

    if (value != null && value.length > AppConfig.maxDescriptionLength) {
      return 'الوصف يجب أن يكون أقل من ${AppConfig.maxDescriptionLength} حرف';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  // File size validation
  static String? validateFileSize(int fileSize) {
    if (fileSize > AppConfig.maxFileSize) {
      final maxSizeMB = AppConfig.maxFileSize / (1024 * 1024);
      return 'حجم الملف يجب أن يكون أقل من ${maxSizeMB.toStringAsFixed(1)} ميجابايت';
    }
    return null;
  }

  // Image file type validation
  static String? validateImageType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    if (!AppConfig.allowedImageTypes.contains(extension)) {
      return 'نوع الملف غير مدعوم. الأنواع المدعومة: ${AppConfig.allowedImageTypes.join(', ')}';
    }
    return null;
  }
}
