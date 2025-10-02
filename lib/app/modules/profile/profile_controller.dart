import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
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

  // --- Main Profile Info ---
  final restaurantName = 'مطعم الذواقة'.obs;
  final email = 'info@gourmethaven.com'.obs;
  final logoUrl = 'https://placehold.co/200x200/333/FFF?text=GP'.obs;
  final bio = 'مأكولات أصيلة من قلب التراث'.obs; // NEW
  final story = 'بدأنا رحلتنا في عام 2010 بشغف لتقديم أشهى الأطباق...'.obs; // NEW

  // --- Reputation Stats ---
  final averageRating = 4.8.obs;
  final reviewCount = 125.obs;
  final responseRate = 0.85.obs;

  // --- Profile Completion ---
  final profileCompletion = 0.0.obs; // NEW: For the progress bar

  // --- Document Status ---
  final documents = <DocumentStatus>[
    DocumentStatus('الرخصة التجارية', 'approved'),
    DocumentStatus('السجل التجاري', 'pending'),
  ].obs;

  // --- Edit Profile State ---
  late TextEditingController restaurantNameController;
  late TextEditingController bioController;
  late TextEditingController storyController;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    restaurantNameController = TextEditingController(text: restaurantName.value);
    bioController = TextEditingController(text: bio.value);
    storyController = TextEditingController(text: story.value);
    calculateProfileCompletion(); // Calculate initial completion
  }

  /// NEW: Calculate the profile completion percentage
  void calculateProfileCompletion() {
    double completion = 0.0;
    // Assign points for each completed field
    if (restaurantName.value.isNotEmpty) completion += 0.25;
    if (logoUrl.value.isNotEmpty && !logoUrl.value.contains('placehold')) completion += 0.25;
    if (bio.value.isNotEmpty) completion += 0.25;
    if (story.value.isNotEmpty) completion += 0.25;

    profileCompletion.value = completion;
  }

  void updateLocationOnMap() {
    CustomSnackbar.showInfo('سيتم تفعيل هذه الميزة قريباً لتحديد موقعك.');
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
        _storage.remove('authToken');
        Get.offAllNamed(Routes.login);
      },
    );
  }

  Future<void> saveProfileChanges() async {
    isSaving.value = true;
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    try {
      // Update local observables
      restaurantName.value = restaurantNameController.text;
      bio.value = bioController.text;
      story.value = storyController.text;

      calculateProfileCompletion(); // Recalculate completion after saving

      Get.back();
      CustomSnackbar.showSuccess('تم حفظ التغييرات بنجاح!');
    } catch (e) {
      CustomSnackbar.showError('حدث خطأ أثناء حفظ التغييرات.');
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
