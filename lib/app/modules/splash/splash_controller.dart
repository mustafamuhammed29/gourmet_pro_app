import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashController extends GetxController {
  final _storage = GetStorage();

  @override
  void onReady() {
    super.onReady();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Wait for a bit on the splash screen for branding purposes
    await Future.delayed(const Duration(seconds: 2));

    final String? token = _storage.read('authToken');

    if (token != null && token.isNotEmpty) {
      // If a token exists, the user is likely logged in
      Get.offAllNamed(Routes.mainWrapper);
    } else {
      // If no token, go to the login screen
      Get.offAllNamed(Routes.login);
    }
  }

  /// Launches WhatsApp with a pre-filled message.
  Future<void> launchWhatsApp() async {
    // Replace with your business phone number including the country code
    const String phoneNumber = '+966000000000';
    const String message = 'أهلاً Gourmet Pro، أنا مهتم بفتح مطعم جديد وأود معرفة المزيد عن خدماتكم.';

    // Encode the message to be URL-safe
    final String encodedMessage = Uri.encodeComponent(message);
    final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      CustomSnackbar.showError('لا يمكن فتح واتساب. يرجى التأكد من تثبيته على جهازك.');
    }
  }
}

