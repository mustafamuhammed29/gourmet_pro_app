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

  Order({
    required this.id,
    required this.dishName,
    required this.price,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      dishName: json['dishName'],
      price: double.parse(json['price'].toString()),
      status: json['status'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
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
}

class OrdersController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final RxList<Order> orders = <Order>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
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
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      CustomSnackbar.showError('فشل في جلب الطلبات.');
    } finally {
      isLoading.value = false;
    }
  }

  /// تحديث حالة الطلب
  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    try {
      final response = await _apiProvider.updateOrderStatus(
        orderId.toString(),
        newStatus,
      );

      if (response.isOk) {
        await fetchOrders();
        CustomSnackbar.showSuccess('تم تحديث حالة الطلب بنجاح!');
      } else {
        throw Exception('Failed to update order status');
      }
    } catch (e) {
      CustomSnackbar.showError('فشل في تحديث حالة الطلب.');
    }
  }
}
