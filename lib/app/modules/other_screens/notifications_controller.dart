import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';

// نموذج بيانات الإشعار
class NotificationItem {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'] ?? 'إشعار جديد',
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // دالة لحساب الوقت المنقضي
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return 'منذ ${(difference.inDays / 7).floor()} أسبوع';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}

class NotificationsController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final isLoading = true.obs;
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getMyNotifications();

      if (response.isOk && response.body is List) {
        final List<dynamic> notificationJson = response.body;
        final notificationList = notificationJson
            .map((json) => NotificationItem.fromJson(json))
            .toList();
        notifications.assignAll(notificationList);
      } else {
        throw Exception('Failed to parse notifications from server response.');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      // في حالة الخطأ، نعرض قائمة فارغة
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await _apiProvider.markNotificationAsRead(notificationId.toString());
      // تحديث الحالة محلياً
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final updatedNotification = NotificationItem(
          id: notifications[index].id,
          title: notifications[index].title,
          message: notifications[index].message,
          isRead: true,
          createdAt: notifications[index].createdAt,
        );
        notifications[index] = updatedNotification;
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
}
