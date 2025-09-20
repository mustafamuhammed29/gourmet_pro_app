import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/dashboard/dashboard_controller.dart';

import '../../../shared/theme/app_colors.dart';

// Convert to StatefulWidget to manage the TextEditingController's lifecycle.
class PromoGeneratorWidget extends StatefulWidget {
  const PromoGeneratorWidget({super.key});

  @override
  State<PromoGeneratorWidget> createState() => _PromoGeneratorWidgetState();
}

class _PromoGeneratorWidgetState extends State<PromoGeneratorWidget> {
  // Find the single instance of our DashboardController.
  final DashboardController controller = Get.find();
  // Create a TextEditingController that is managed by this widget's state.
  late final TextEditingController _promoThemeController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller when the widget is first created.
    _promoThemeController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed from the screen.
    _promoThemeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B0764), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '✨ مولد أفكار العروض',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'أدخل موضوعاً واحصل على أفكار ترويجية مبتكرة.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          _buildInputWithButton(),
          const SizedBox(height: 12),
          _buildResultsView(),
        ],
      ),
    );
  }

  Widget _buildInputWithButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // Use the local controller.
              controller: _promoThemeController,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'مثال: اليوم الوطني، صيف',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Obx(
                () => IconButton(
              onPressed: controller.isPromoLoading.value
                  ? null
              // Pass the text from the local controller to the method.
                  : () => controller.getPromotionalIdeas(_promoThemeController.text),
              icon: controller.isPromoLoading.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.auto_awesome, color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    return Obx(
          () => Container(
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(minHeight: 80),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: controller.isPromoLoading.value
            ? const Center(
            child: Text('... يتم توليد الأفكار',
                style: TextStyle(color: Colors.white70)))
            : HtmlWidget(
          controller.promoIdeaResult.value.isEmpty
              ? '<p style="color: #9CA3AF; text-align: center;">ستظهر الأفكار هنا...</p>'
              : controller.promoIdeaResult.value,
          textStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

