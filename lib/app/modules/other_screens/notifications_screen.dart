import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

// A simple local model for notification data.
class NotificationItem {
  final String title;
  final String timeAgo;
  final bool isNew;

  // The constructor is now marked as const.
  const NotificationItem({
    required this.title,
    required this.timeAgo,
    this.isNew = false,
  });
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // Dummy data for demonstration purposes.
  // We can now use 'const' inside the list because the NotificationItem constructor is const.
  final List<NotificationItem> _notifications = const [
    NotificationItem(
      title: 'نصيحة جديدة: قم بتحديث صور أطباقك!',
      timeAgo: 'منذ 6 ساعات',
      isNew: true,
    ),
    NotificationItem(
      title: 'تمت الموافقة على طلبك لخدمة "استشارات الطهي".',
      timeAgo: 'منذ يوم واحد',
    ),
    NotificationItem(
      title: 'لديك تقييم جديد بـ 5 نجوم من أحد الزبائن.',
      timeAgo: 'منذ 3 أيام',
    ),
    NotificationItem(
      title: 'تذكير: عرض "خصم الصيف" سينتهي قريباً.',
      timeAgo: 'منذ أسبوع واحد',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _NotificationCard(notification: notification);
        },
      ),
    );
  }
}

// A dedicated widget for a single notification item for cleaner code.
class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: notification.isNew
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
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
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
    );
  }
}

