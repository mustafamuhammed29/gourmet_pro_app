import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsController extends GetxController {
  final GetStorage _storage = GetStorage();
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // معلومات التطبيق
  final appVersion = '1.0.0'.obs;
  final lastLogin = DateTime.now().obs;

  // اللغة
  final currentLanguage = 'العربية'.obs;

  // الموقع
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final isUpdatingLocation = false.obs;

  // معلومات المستخدم
  final restaurantName = ''.obs;
  final email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
    fetchUserInfo();
  }

  void loadSettings() {
    // تحميل آخر دخول من التخزين المحلي
    final lastLoginStr = _storage.read('last_login');
    if (lastLoginStr != null) {
      lastLogin.value = DateTime.parse(lastLoginStr);
    }

    // تحميل اللغة الحالية
    final lang = _storage.read('language') ?? 'العربية';
    currentLanguage.value = lang;

    // تحميل الموقع المحفوظ
    final lat = _storage.read('latitude');
    final lng = _storage.read('longitude');
    if (lat != null && lng != null) {
      latitude.value = lat;
      longitude.value = lng;
    }
  }

  Future<void> fetchUserInfo() async {
    try {
      final response = await _apiProvider.getMyRestaurant();
      if (response.isOk) {
        final data = response.body;
        restaurantName.value = data['name'] ?? '';
        email.value = data['owner']?['email'] ?? '';
        
        // تحديث الموقع من الخادم إذا كان موجوداً
        if (data['latitude'] != null && data['longitude'] != null) {
          latitude.value = double.parse(data['latitude'].toString());
          longitude.value = double.parse(data['longitude'].toString());
        }
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> updateLocation() async {
    try {
      isUpdatingLocation.value = true;

      // 1. طلب إذن الموقع
      final permission = await Permission.location.request();
      if (!permission.isGranted) {
        CustomSnackbar.showError('يجب السماح بالوصول إلى الموقع');
        return;
      }

      // 2. الحصول على الموقع الحالي
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // 3. حفظ الموقع محلياً
      _storage.write('latitude', position.latitude);
      _storage.write('longitude', position.longitude);

      // 4. إرسال الموقع إلى الخادم
      final response = await _apiProvider.updateMyRestaurant({
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
      });

      if (response.isOk) {
        CustomSnackbar.showSuccess('تم تحديث الموقع بنجاح');
      } else {
        throw Exception('Failed to update location on server');
      }
    } catch (e) {
      CustomSnackbar.showError('فشل في تحديث الموقع: ${e.toString()}');
    } finally {
      isUpdatingLocation.value = false;
    }
  }

  void changeLanguage(String language) {
    currentLanguage.value = language;
    _storage.write('language', language);

    // تطبيق اللغة في GetX
    if (language == 'English') {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('ar', 'SA'));
    }

    CustomSnackbar.showSuccess('تم تغيير اللغة إلى $language');
  }

  String get formattedLastLogin {
    final now = DateTime.now();
    final difference = now.difference(lastLogin.value);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  String get formattedLocation {
    if (latitude.value == 0.0 && longitude.value == 0.0) {
      return 'لم يتم تحديد الموقع';
    }
    return '${latitude.value.toStringAsFixed(4)}, ${longitude.value.toStringAsFixed(4)}';
  }
}
