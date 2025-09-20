import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  // --- DEPENDENCIES ---
  final _storage = GetStorage();

  // --- STATE FOR PROFILE SCREEN ---
  final restaurantName = 'مطعم الذواقة'.obs;
  final email = 'info@gourmethaven.com'.obs;
  final logoUrl = 'https://placehold.co/200x200/333/FFF?text=Logo'.obs;

  // --- STATE FOR EDIT PROFILE SCREEN ---
  late TextEditingController restaurantNameController;
  late TextEditingController bioController;
  late TextEditingController storyController;
  final isSaving = false.obs;

  // --- LIFECYCLE METHODS ---
  @override
  void onInit() {
    super.onInit();
    // Initialize text controllers with current profile data
    restaurantNameController = TextEditingController(
      text: restaurantName.value,
    );
    bioController = TextEditingController(text: 'مأكولات أصيلة');
    storyController = TextEditingController(text: 'نبذة عن تاريخ المطعم...');
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    restaurantNameController.dispose();
    bioController.dispose();
    storyController.dispose();
    super.onClose();
  }

  // --- PUBLIC METHODS ---

  /// Simulates saving profile changes to the backend.
  Future<void> saveProfileChanges() async {
    try {
      isSaving.value = true;
      await Future.delayed(const Duration(seconds: 2)); // Simulate network call

      // Update the main profile data with the new values from the form
      restaurantName.value = restaurantNameController.text;
      // In a real app, you would save bioController.text and storyController.text as well.

      Get.back(); // Go back to the profile screen
      Get.snackbar(
        'نجاح',
        'تم حفظ التغييرات بنجاح!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حفظ التغييرات. حاول مرة أخرى.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Logs the user out by clearing storage and navigating to the login screen.
  void logout() {
    // Show a confirmation dialog before logging out
    Get.defaultDialog(
      title: "تسجيل الخروج",
      middleText: "هل أنت متأكد أنك تريد تسجيل الخروج؟",
      backgroundColor: const Color(0xFF1F2937), // bgSecondary
      titleStyle: const TextStyle(color: Colors.white),
      middleTextStyle: const TextStyle(color: Colors.white70),
      textConfirm: "نعم",
      textCancel: "لا",
      cancelTextColor: Colors.white,
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFD97706), // accentHover
      onConfirm: () {
        _storage.remove('authToken'); // Clear the stored token
        Get.offAllNamed(
          Routes.login,
        ); // Navigate and remove all previous routes
      },
    );
  }
}
