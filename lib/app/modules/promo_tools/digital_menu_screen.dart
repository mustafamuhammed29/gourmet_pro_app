import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/models/product_model.dart';
import 'package:gourmet_pro_app/app/modules/promo_tools/promo_tools_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

class DigitalMenuScreen extends GetView<PromoToolsController> {
  const DigitalMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgSecondary,
        elevation: 0,
        centerTitle: true,
        title: Obx(
              () => Text(
            'قائمة طعام ${controller.restaurantName.value}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: controller.obx(
            (products) {
          if (products == null || products.isEmpty) {
            return const Center(
              child: Text(
                'القائمة فارغة حالياً.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          // Group products by category
          final Map<String, List<ProductModel>> groupedProducts = {};
          for (var product in products) {
            (groupedProducts[product.category] ??= []).add(product);
          }
          final categories = groupedProducts.keys.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final productsInCategory = groupedProducts[category]!;
              return _buildCategorySection(category, productsInCategory);
            },
          );
        },
        onLoading: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        onError: (error) => Center(
          child: Text(
            error ?? 'حدث خطأ أثناء تحميل القائمة.',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(
      String category, List<ProductModel> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Text(
            category,
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) =>
                _buildMenuItem(products[index]),
            separatorBuilder: (context, index) => const Divider(
              color: AppColors.bgTertiary,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(ProductModel product) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (product.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      product.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${product.price}\$',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
