import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/market_analysis/market_analysis_controller.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';

class RestaurantDetailsScreen extends GetView<MarketAnalysisController> {
  const RestaurantDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Safely get the passed restaurant object
    final Restaurant? restaurant = Get.arguments as Restaurant?;

    // Show an error screen if no restaurant data is available
    if (restaurant == null) {
      return const Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(
          child: Text(
            'لم يتم العثور على بيانات المطعم.',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(restaurant),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'معلومات عامة',
                    style: Get.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'العنوان: 456 شارع فرعي، المدينة',
                    style: Get.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'عرض القائمة (للاستلهام)',
                    onPressed: () {},
                    isLoading: false.obs,
                    // FIX: Changed from 'backgroundColor' to 'isPrimary'
                    isPrimary: false,
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
      expandedHeight: 200.0,
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
              'https://placehold.co/600x400/111/FFF?text=${restaurant.name.replaceAll(' ', '+')}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: AppColors.bgTertiary),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
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

