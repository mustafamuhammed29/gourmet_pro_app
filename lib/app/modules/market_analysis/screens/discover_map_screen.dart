import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/market_analysis/market_analysis_controller.dart';
import '../../../shared/theme/app_colors.dart';

class DiscoverMapScreen extends GetView<MarketAnalysisController> {
  const DiscoverMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Column(
        children: [
          // --- Top: Map View ---
          SizedBox(
            height: Get.height * 0.45,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    'https://placehold.co/400x800/374151/9CA3AF?text=Map+View',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: AppColors.bgTertiary),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'تحليل السوق',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'ابحث بالمنطقة...',
                            hintStyle:
                            const TextStyle(color: AppColors.textSecondary),
                            filled: true,
                            fillColor: AppColors.bgSecondary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.search,
                                color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // --- Bottom: List View ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildFilters(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildRestaurantList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 40,
      // FIX: Removed the Obx from here to wrap only the changing part inside the builder.
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.filters.length,
        itemBuilder: (context, index) {
          // FIX: Added Obx here to only rebuild the ChoiceChip when its state changes.
          return Obx(() {
            final isActive = controller.selectedFilterIndex.value == index;
            return ChoiceChip(
              label: Text(controller.filters[index]),
              selected: isActive,
              onSelected: (selected) {
                if (selected) {
                  controller.changeFilter(index);
                }
              },
              backgroundColor: AppColors.bgSecondary,
              selectedColor: AppColors.accent,
              labelStyle: TextStyle(
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide.none,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            );
          });
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }

  Widget _buildRestaurantList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(color: AppColors.accent));
      }
      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: controller.restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = controller.restaurants[index];
          return _RestaurantCard(restaurant: restaurant);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      );
    });
  }
}

class _RestaurantCard extends GetView<MarketAnalysisController> {
  final Restaurant restaurant;
  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.goToRestaurantDetails(restaurant),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                restaurant.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: AppColors.bgTertiary,
                    child: const Icon(Icons.image_not_supported_outlined,
                        color: AppColors.textSecondary)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          restaurant.cuisine,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rating.toString(),
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (restaurant.hasOffer)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child:
                Icon(Icons.local_offer, color: AppColors.accent, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}

