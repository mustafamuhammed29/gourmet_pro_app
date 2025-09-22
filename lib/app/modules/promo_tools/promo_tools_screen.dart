import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/promo_tools/promo_tools_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PromoToolsScreen extends GetView<PromoToolsController> {
  const PromoToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'أدوات التسويق',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // Using controller.obx for robust state management
          child: controller.obx(
                (state) => _buildQrCodeView(),
            onLoading:
            const CircularProgressIndicator(color: AppColors.accent),
            onEmpty: const Text(
              'أضف منتجات أولاً لإنشاء قائمتك الرقمية.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            onError: (error) => Text(
              error ?? 'حدث خطأ غير متوقع',
              style: const TextStyle(color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // This widget is displayed when the products are loaded successfully.
  Widget _buildQrCodeView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'رمز QR لقائمتك الرقمية',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'يمكن لزبائنك مسح هذا الرمز لعرض قائمة طعامك مباشرة على هواتفهم.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 32),
        // The QR Code Widget
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: QrImageView(
            data: controller.digitalMenuUrl,
            version: QrVersions.auto,
            size: 200.0,
            // You can embed a logo in the middle of the QR code
            // embeddedImage: const AssetImage('assets/logo.png'),
            // embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(40, 40)),
          ),
        ),
        const SizedBox(height: 32),
        // Action Buttons
        CustomButton(
          text: 'معاينة القائمة',
          onPressed: () => controller.previewDigitalMenu(),
          isLoading: false.obs, // This button doesn't have a loading state
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'حفظ الرمز كصورة',
          onPressed: () => controller.saveQrCode(),
          isLoading: false.obs,
          isPrimary: false, // Secondary button style
        ),
      ],
    );
  }
}

