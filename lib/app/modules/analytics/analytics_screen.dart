import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/analytics/analytics_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_button.dart';

class AnalyticsScreen extends GetView<AnalyticsController> {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحليلات والأداء'),
        centerTitle: true,
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildStatsGrid(),
            const SizedBox(height: 24),
            _buildHealthScoreCard(),
            const SizedBox(height: 24),
            _buildGrowthOpportunitiesCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Obx(() => GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _StatCard(title: 'زيارات الملف الشخصي', value: controller.profileVisits.value.toString()),
        _StatCard(title: 'نقرات القائمة', value: controller.menuClicks.value.toString()),
      ],
    ));
  }

  Widget _buildHealthScoreCard() {
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'تقييم صحة المطعم',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: controller.restaurantHealth.value,
              minHeight: 10,
              backgroundColor: AppColors.bgTertiary,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'أداء جيد! أكمل ملفك للوصول إلى 100%.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildGrowthOpportunitiesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'فرص للنمو',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => CustomButton(
            text: '✨ الحصول على رؤى ذكية',
            onPressed: () => controller.fetchAnalyticsInsights(),
            isLoading: controller.isLoadingInsights,
          )),
          const SizedBox(height: 16),
          Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: controller.aiInsights.isNotEmpty
                ? const EdgeInsets.all(12)
                : EdgeInsets.zero,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.bgTertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: controller.aiInsights.isNotEmpty
                ? HtmlWidget(
              controller.aiInsights.value,
              textStyle: const TextStyle(color: AppColors.textPrimary),
            )
                : const SizedBox(height: 80),
          )),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
