import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/other_screens/notifications_controller.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // إنشاء Controller
    final controller = Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'الإشعارات',
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
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          );
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text(
              'لا توجد إشعارات',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return _NotificationCard(
              notification: notification,
              onTap: () => controller.markAsRead(notification.id),
            );
          },
        );
      }),
    );
  }
}

// A dedicated widget for a single notification item for cleaner code.
class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  final NotificationItem notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: !notification.isRead
              ? const Border(
                  right: BorderSide(color: AppColors.accent, width: 3),
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight:
                    notification.isRead ? FontWeight.normal : FontWeight.w600,
                fontSize: 15,
              ),
            ),
            if (notification.message.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                notification.message,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              notification.timeAgo,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
