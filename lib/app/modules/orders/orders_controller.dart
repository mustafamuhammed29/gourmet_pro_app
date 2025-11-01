import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';

// نموذج بيانات الطلب
class Order {
  final int id;
  final String dishName;
  final double price;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final String type; // ✨ إضافة نوع الطلب: 'order' أو 'service'

  Order({
    required this.id,
    required this.dishName,
    required this.price,
    required this.status,
    this.notes,
    required this.createdAt,
    this.type = 'order', // ✨ القيمة الافتراضية
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      dishName: json['dishName'] ?? json['serviceName'] ?? 'غير محدد',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      status: json['status'],
      notes: json['notes'] ?? json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      type: 'order',
    );
  }

  // ✨ دالة جديدة لتحويل طلب خدمة من JSON
  factory Order.fromServiceJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      dishName: json['serviceName'] ?? 'خدمة غير محددة',
      price: 0.0, // الخدمات قد لا تحتوي على سعر
      status: json['status'],
      notes: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      type: 'service', // ✨ نوع الطلب: خدمة
    );
  }

  String get statusArabic {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'in-progress':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  // ✨ دالة لعرض نوع الطلب بالعربية
  String get typeArabic {
    return type == 'service' ? 'خدمة' : 'طلب';
  }
}

class OrdersController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final RxList<Order> orders = <Order>[].obs;
  final RxList<Order> serviceRequests = <Order>[].obs; // ✨ قائمة منفصلة للخدمات
  final RxList<Order> allItems = <Order>[].obs; // ✨ قائمة مدمجة
  final isLoading = true.obs;

  // ✨ متغير للتبديل بين العرض
  final selectedTab = 0.obs; // 0: الكل، 1: الطلبات، 2: الخدمات

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  /// ✨ جلب جميع البيانات (الطلبات والخدمات)
  Future<void> fetchAllData() async {
    await Future.wait([
      fetchOrders(),
      fetchServiceRequests(),
    ]);
    _mergeAllItems();
  }

  /// جلب جميع الطلبات من الخادم
  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getMyOrders();

      if (response.isOk && response.body is List) {
        final List<dynamic> ordersJson = response.body;
        final ordersList = ordersJson
            .map((json) => Order.fromJson(json))
            .toList();
        orders.assignAll(ordersList);
      } else {
        // في حالة عدم وجود طلبات، نضع قائمة فارغة
        orders.clear();
      }
    } catch (e) {
      CustomSnackbar.showError('فشل في جلب الطلبات.');
      orders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// ✨ جلب جميع طلبات الخدمات من الخادم
  Future<void> fetchServiceRequests() async {
    try {
      final response = await _apiProvider.getMyServiceRequests();

      if (response.isOk && response.body is List) {
        final List<dynamic> servicesJson = response.body;
        final servicesList = servicesJson
            .map((json) => Order.fromServiceJson(json))
            .toList();
        serviceRequests.assignAll(servicesList);
      } else {
        serviceRequests.clear();
      }
    } catch (e) {
      // في حالة الفشل، نضع قائمة فارغة
      serviceRequests.clear();
    }
  }

  /// ✨ دمج جميع العناصر في قائمة واحدة
  void _mergeAllItems() {
    final combined = <Order>[];
    combined.addAll(orders);
    combined.addAll(serviceRequests);
    // ترتيب حسب التاريخ (الأحدث أولاً)
    combined.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    allItems.assignAll(combined);
  }

  /// تحديث حالة الطلب
  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    try {
      final response = await _apiProvider.updateOrderStatus(
        orderId.toString(),
        newStatus,
      );

      if (response.isOk) {
        await fetchAllData();
        CustomSnackbar.showSuccess('تم تحديث حالة الطلب بنجاح!');
      } else {
        throw Exception('Failed to update order status');
      }
    } catch (e) {
      CustomSnackbar.showError('فشل في تحديث حالة الطلب.');
    }
  }

  /// ✨ الحصول على القائمة المناسبة حسب التبويب المختار
  List<Order> get displayedItems {
    switch (selectedTab.value) {
      case 1:
        return orders;
      case 2:
        return serviceRequests;
      default:
        return allItems;
    }
  }
}
