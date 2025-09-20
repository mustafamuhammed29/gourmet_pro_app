import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/models/product_model.dart';
import 'package:gourmet_pro_app/app/modules/product_management/product_management_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

class ManageMenuScreen extends GetView<ProductManagementController> {
  const ManageMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'إدارة القائمة',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: AppColors.textPrimary, size: 28),
            onPressed: () => controller.goToAddDish(),
          ),
        ],
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }
          if (controller.products.isEmpty) {
            return const Center(
              child: Text(
                'قائمتك فارغة! أضف طبقك الأول.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              // FIX: Added a unique key to each card to prevent rendering issues.
              return _DishCard(
                key: ValueKey(product.id),
                product: product,
                controller: controller,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          );
        },
      ),
    );
  }
}

// A dedicated widget for a single dish card for cleaner code.
class _DishCard extends StatelessWidget {
  final ProductModel product;
  final ProductManagementController controller;

  const _DishCard({super.key, required this.product, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Dish Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              product.imageUrl ??
                  'https://placehold.co/100x100/333/FFF?text=Dish',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              // More robust error handling
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: AppColors.bgTertiary,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Dish Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Simplified the layout by removing the nested Flexible widget.
                // The Expanded parent already constrains the width.
                Text(
                  product.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  product.category,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${product.price} \$',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Action Buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 90,
                child: TextButton(
                  onPressed: () => controller.goToEditDish(product),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.bgTertiary,
                    foregroundColor: AppColors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('تعديل'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 90,
                child: TextButton(
                  onPressed: () => controller.goToSocialPostGenerator(product),
                  style: TextButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF4F46E5), // Indigo color from design
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('✨ ترويج'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

