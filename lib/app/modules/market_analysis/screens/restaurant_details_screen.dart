import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/market_analysis/market_analysis_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_button.dart';

class RestaurantDetailsScreen extends GetView<MarketAnalysisController> {
  const RestaurantDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Safely get the passed restaurant object from the arguments.
    final Restaurant? restaurant = Get.arguments as Restaurant?;

    // If for some reason no restaurant data was passed, show a safe error screen.
    if (restaurant == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: AppBar(backgroundColor: AppColors.bgPrimary),
        body: const Center(
          child: Text(
            'لم يتم العثور على بيانات المطعم.',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      // Using CustomScrollView to create the collapsing header effect.
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(restaurant),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'معلومات عامة',
                    style: Get.textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'العنوان: 456 شارع فرعي، المدينة', // Placeholder address
                    style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'عرض القائمة (للاستلهام)',
                    onPressed: () {
                      Get.snackbar('قيد التطوير', 'سيتم تفعيل هذه الميزة قريباً.');
                    },
                    isLoading: false.obs,
                    isPrimary: false, // Use the secondary style for this button
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Restaurant restaurant) {
    return SliverAppBar(
      expandedHeight: 220.0,
      backgroundColor: AppColors.bgPrimary,
      pinned: true,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          restaurant.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              restaurant.imageUrl.replaceFirst('100x100', '600x400'), // Get a larger image
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: AppColors.bgTertiary),
            ),
            // Add a gradient overlay for better title readability.
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

