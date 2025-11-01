import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:image_picker/image_picker.dart'; // ✨ استيراد مكتبة اختيار الصور
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/custom_snackbar.dart';

// Models for profile data
class DocumentStatus {
  final String name;
  final String status; // 'pending', 'approved', 'rejected'
  DocumentStatus(this.name, this.status);
}

class ProfileController extends GetxController {
  final _storage = GetStorage();
  final ApiProvider _apiProvider = Get.find<ApiProvider>(); // ✨ حقن الـ API Provider
  final ImagePicker _picker = ImagePicker(); // ✨ مكتبة اختيار الصور

  // --- Main Profile Info ---
  final restaurantName = ''.obs; // ✨ سيتم جلبه من الـ API
  final email = ''.obs; // ✨ سيتم جلبه من الـ API
  final logoUrl = 'https://placehold.co/200x200/333/FFF?text=GP'.obs;
  final bio = ''.obs;
  final story = ''.obs;

  // --- Reputation Stats ---
  final averageRating = 4.8.obs;
  final reviewCount = 125.obs;
  final responseRate = 0.85.obs;

  // --- Profile Completion ---
  final profileCompletion = 0.0.obs;

  // --- Document Status ---
  final documents = <DocumentStatus>[].obs; // ✨ سيتم جلبه من الـ API

  // --- Edit Profile State ---
  late TextEditingController restaurantNameController;
  late TextEditingController bioController;
  late TextEditingController storyController;
  final isSaving = false.obs;
  final isLoadingProfile = true.obs; // ✨ متغير جديد لحالة التحميل
  final Rx<File?> pickedLogo = Rx<File?>(null); // ✨ الصورة المختارة

  @override
  void onInit() {
    super.onInit();
    restaurantNameController = TextEditingController();
    bioController = TextEditingController();
    storyController = TextEditingController();
    fetchProfileData(); // ✨ استدعاء الدالة لجلب البيانات
  }

  /// ✨ دالة جديدة لجلب بيانات الملف الشخصي من الخادم
  Future<void> fetchProfileData() async {
    try {
      isLoadingProfile.value = true;
      final response = await _apiProvider.getMyRestaurant();

      if (response.isOk) {
        final data = response.body;

        // تحديث البيانات المرصودة (observables)
        restaurantName.value = data['name'] ?? '';
        // ✨ جلب البريد الإلكتروني من بيانات المالك
        if (data['owner'] != null) {
          email.value = data['owner']['email'] ?? '';
        }
        bio.value = data['bio'] ?? 'نبذة تعريفية قصيرة عن المطعم';
        story.value = data['story'] ?? 'قصتنا...';
        
        // ✨ جلب رابط الشعار إذا كان موجوداً
        if (data['logoUrl'] != null && data['logoUrl'].isNotEmpty) {
          logoUrl.value = data['logoUrl'];
        }

        // تحديث متحكمات النصوص للنموذج
        restaurantNameController.text = restaurantName.value;
        bioController.text = bio.value;
        storyController.text = story.value;

        // ✨ جلب حالة المستندات من الخادم
        await fetchDocumentsStatus();

        calculateProfileCompletion();
      } else {
        CustomSnackbar.showError('فشل في جلب بيانات الملف الشخصي.');
      }
    } catch (e) {
      CustomSnackbar.showError('حدث خطأ في الشبكة: ${e.toString()}');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  void calculateProfileCompletion() {
    double completion = 0.0;
    if (restaurantName.value.isNotEmpty) completion += 0.25;
    if (logoUrl.value.isNotEmpty && !logoUrl.value.contains('placehold'))
      completion += 0.25;
    if (bio.value.isNotEmpty) completion += 0.25;
    if (story.value.isNotEmpty) completion += 0.25;

    profileCompletion.value = completion;
  }

  /// ✨ دالة جديدة لجلب حالة المستندات
  Future<void> fetchDocumentsStatus() async {
    try {
      final response = await _apiProvider.getMyDocuments();

      if (response.isOk && response.body is List) {
        final List<dynamic> docsJson = response.body;
        final docsList = docsJson
            .map((doc) => DocumentStatus(
                  _getDocumentName(doc['type']),
                  doc['status'],
                ))
            .toList();
        documents.assignAll(docsList);
      }
    } catch (e) {
      // في حالة الفشل، نعرض بيانات افتراضية
      documents.assignAll([
        DocumentStatus('الرخصة التجارية', 'pending'),
        DocumentStatus('السجل التجاري', 'pending'),
      ]);
    }
  }

  String _getDocumentName(String type) {
    switch (type) {
      case 'license':
        return 'الرخصة التجارية';
      case 'commercial_registry':
        return 'السجل التجاري';
      default:
        return type;
    }
  }

  /// ✨ دالة اختيار الصورة من المعرض
  Future<void> pickLogoImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );
      
      if (image != null) {
        pickedLogo.value = File(image.path);
        // تحديث الصورة المعروضة مؤقتاً
        logoUrl.value = image.path;
        CustomSnackbar.showSuccess('تم اختيار الصورة! اضغط "حفظ التغييرات" لرفعها.');
      }
    } catch (e) {
      CustomSnackbar.showError('فشل في اختيار الصورة: ${e.toString()}');
    }
  }

  void updateLocationOnMap() {
    // فتح صفحة الإعدادات لتحديث الموقع
    Get.toNamed('/settings');
  }

  void manageSubscription() {
    CustomSnackbar.showInfo('سيتم تفعيل هذه الميزة قريباً لإدارة اشتراكك.');
  }

  void logout() {
    Get.defaultDialog(
      title: "تسجيل الخروج",
      middleText: "هل أنت متأكد أنك تريد تسجيل الخروج؟",
      backgroundColor: AppColors.bgSecondary,
      titleStyle: const TextStyle(color: AppColors.textPrimary),
      middleTextStyle: const TextStyle(color: AppColors.textSecondary),
      textConfirm: "نعم",
      textCancel: "لا",
      cancelTextColor: Colors.white,
      confirmTextColor: Colors.white,
      buttonColor: AppColors.accentHover,
      onConfirm: () {
        _storage.remove('token');
        Get.offAllNamed(Routes.login);
      },
    );
  }

  Future<void> saveProfileChanges() async {
    isSaving.value = true;
    try {
      final dataToUpdate = {
        'name': restaurantNameController.text,
        'bio': bioController.text,
        'story': storyController.text,
      };

      // ✨ استدعاء الـ API لتحديث البيانات مع الصورة
      final response = await _apiProvider.updateMyRestaurantWithLogo(
        dataToUpdate,
        logo: pickedLogo.value,
      );

      if (response.isOk) {
        pickedLogo.value = null; // مسح الصورة المختارة
        await fetchProfileData(); // إعادة جلب البيانات لتحديث الواجهة
        Get.back();
        CustomSnackbar.showSuccess('تم حفظ التغييرات بنجاح!');
      } else {
        throw Exception('Failed to save changes');
      }
    } catch (e) {
      CustomSnackbar.showError('حدث خطأ أثناء حفظ التغييرات: ${e.toString()}');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    restaurantNameController.dispose();
    bioController.dispose();
    storyController.dispose();
    super.onClose();
  }
}
