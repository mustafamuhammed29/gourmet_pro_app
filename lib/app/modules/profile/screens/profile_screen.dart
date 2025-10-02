import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/profile/profile_controller.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      // Using CustomScrollView for the magic of animated header
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileCompletionCard(),
                  const SizedBox(height: 24),
                  _buildReputationStats(),
                  const SizedBox(height: 24),
                  _buildInfoCard(title: 'نبذة عنا', content: controller.bio.value),
                  const SizedBox(height: 16),
                  _buildInfoCard(title: 'قصتنا', content: controller.story.value),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildDocumentStatus(),
                  const SizedBox(height: 24),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // The magic starts here: SliverAppBar for a collapsible, animated header
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.bgSecondary,
      elevation: 2,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => Get.toNamed(Routes.editProfile),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
        title: Text(
          controller.restaurantName.value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // You can add a background image here
            // Image.network('...', fit: BoxFit.cover),
            Container(color: AppColors.bgPrimary.withOpacity(0.8)),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.bgTertiary,
                    child: ClipOval(
                      child: Image.network(
                        controller.logoUrl.value,
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.storefront, size: 45, color: AppColors.textSecondary);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.email.value,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Magical Touch #2: Profile Completion Card
  Widget _buildProfileCompletionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(
            () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'اكتمال ملفك الشخصي',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${(controller.profileCompletion.value * 100).toInt()}%',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: controller.profileCompletion.value,
                backgroundColor: AppColors.bgTertiary,
                color: AppColors.accent,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.profileCompletion.value < 1.0
                  ? 'أكمل ملفك لجذب المزيد من العملاء!'
                  : 'ملفك الشخصي مكتمل ورائع!',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReputationStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(Icons.star_half, '${controller.averageRating.value}', 'متوسط التقييم'),
        _buildStatItem(Icons.rate_review_outlined, '${controller.reviewCount.value}', 'تقييم'),
        _buildStatItem(Icons.quickreply_outlined, '${(controller.responseRate.value * 100).toInt()}%', 'معدل الرد'),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }

  // Magical Touch #3 & 4: Reusable Info Cards and Quick Actions
  Widget _buildInfoCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(child: _buildActionChip(Icons.location_on_outlined, 'تحديث الموقع', controller.updateLocationOnMap)),
        const SizedBox(width: 12),
        Expanded(child: _buildActionChip(Icons.card_membership_outlined, 'الاشتراك', controller.manageSubscription)),
      ],
    );
  }

  Widget _buildActionChip(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accent, size: 24),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('حالة المستندات', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Obx(
                () => Column(
              children: controller.documents.map((doc) => _buildDocumentRow(doc)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(DocumentStatus doc) {
    IconData statusIcon;
    Color statusColor;
    String statusText;

    switch (doc.status) {
      case 'approved':
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        statusText = 'مقبول';
        break;
      case 'pending':
        statusIcon = Icons.hourglass_top;
        statusColor = Colors.orange;
        statusText = 'قيد المراجعة';
        break;
      default:
        statusIcon = Icons.cancel;
        statusColor = Colors.red;
        statusText = 'مرفوض';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(Icons.description_outlined, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(doc.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
          ),
          const SizedBox(width: 12),
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 4),
          Text(statusText, style: TextStyle(color: statusColor, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => controller.logout(),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.bgSecondary.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.logout, color: Colors.redAccent),
        label: const Text('تسجيل الخروج', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
