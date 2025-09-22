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
  final logoUrl = 'https://placehold.co/200x200/333/FFF?text=Logo'.obs;

  // --- NEW: Reputation Stats ---
  final averageRating = 4.8.obs;
  final reviewCount = 125.obs;
  final responseRate = 0.85.obs; // 85% response rate

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
    bioController = TextEditingController(text: 'مأكولات أصيلة');
    storyController = TextEditingController(text: 'نبذة عن تاريخ المطعم...');
  }

  /// Placeholder for updating location on map.
  void updateLocationOnMap() {
    CustomSnackbar.showInfo('سيتم تفعيل هذه الميزة قريباً لتمكينك من تحديد موقعك على الخريطة.');
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

  Future<void> saveProfileChanges() async { /* ... */ }

  @override
  void onClose() {
    restaurantNameController.dispose();
    bioController.dispose();
    storyController.dispose();
    super.onClose();
  }
}

