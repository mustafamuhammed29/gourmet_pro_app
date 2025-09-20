import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/shared/constants/api_constants.dart';

// هذا الكلاس هو المسؤول الوحيد عن التحدث مع الـ API الخاص بنا
class ApiProvider extends GetConnect {
  final GetStorage _storage = GetStorage();

  // هذه الدالة تعمل تلقائياً عند تهيئة الكلاس
  @override
  void onInit() {
    // تحديد رابط الـ API الأساسي لكل الطلبات القادمة
    httpClient.baseUrl = ApiConstants.baseUrl;

    // إضافة "معترض" للطلبات قبل إرسالها
    httpClient.addRequestModifier<dynamic>((request) {
      // قراءة التوكن من الذاكرة المحلية
      final token = _storage.read('token');

      // إذا كان هناك توكن، قم بإضافته إلى ترويسة الطلب
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    // إضافة "معترض" للاستجابات بعد استلامها
    httpClient.addResponseModifier((request, response) {
      // في حال كانت الاستجابة 401 (غير مصرح به)، يمكننا تنفيذ إجراء معين
      // مثل تسجيل الخروج التلقائي للمستخدم
      if (response.statusCode == 401) {
        print("Unauthorized! Logging out...");
        _storage.remove('token'); // حذف التوكن
        Get.offAllNamed('/login'); // توجيه المستخدم لشاشة الدخول
      }
      return response;
    });
    super.onInit();
  }

  // === دوال المصادقة ===
  Future<Response> login(String email, String password) =>
      post('/auth/login', {'email': email, 'password': password});

  Future<Response> register(Map<String, dynamic> data) =>
      post('/auth/register', data);

  // === دوال إدارة المنتجات ===
  Future<Response> getProducts() => get('/products');

  Future<Response> createProduct(Map<String, dynamic> data) =>
      post('/products', data);

  Future<Response> updateProduct(String id, Map<String, dynamic> data) =>
      patch('/products/$id', data);

  Future<Response> deleteProduct(String id) => delete('/products/$id');
}

