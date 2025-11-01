import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';

class ApiProvider extends GetConnect {
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    // 1. تعيين الرابط الأساسي
    httpClient.baseUrl = ApiConstants.baseUrl;

    // 2. معترض الطلب: إضافة الـ Token تلقائيًا قبل إرسال أي طلب
    httpClient.addRequestModifier<dynamic>((request) {
      final token = _storage.read('token');
      // يتم البحث عن الرمز وإضافته إذا كان موجودًا
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
        // لا نحتاج لتعيين 'Content-Type' هنا، لأنه سيتم تحديده
        // تلقائياً بواسطة GetConnect بناءً على نوع البيانات المرسلة.
      }
      return request;
    });

    // 3. معترض الاستجابة: معالجة الأخطاء الشائعة مثل انتهاء صلاحية الـ Token (401)
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        CustomSnackbar.showError('جلسة المستخدم انتهت. الرجاء تسجيل الدخول مرة أخرى.');
        // حذف الـ Token من التخزين وإعادة توجيه المستخدم لصفحة تسجيل الدخول
        _storage.remove('token');
        Get.offAllNamed(Routes.login);
      } else if (response.hasError) {
        // يمكنك إضافة معالجة عامة هنا لأي أخطاء أخرى
        // CustomSnackbar.showError(response.bodyString ?? 'حدث خطأ غير معروف');
      }
      return response;
    });

    super.onInit();
  }

  // --- Auth Functions ---
  Future<Response> login(String email, String password) =>
      post('/auth/login', {'email': email, 'password': password});

  // يجب تحديث هذه الدالة لحفظ الـ Token عند النجاح في شاشة الـ Auth Controller
  Future<http.Response> registerAndUpload({
    required Map<String, String> data,
    required File licenseFile,
    required File registryFile,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/auth/register');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll(data);

    request.files.add(
      await http.MultipartFile.fromPath(
        'licenseFile',
        licenseFile.path,
        filename: licenseFile.path.split('/').last,
      ),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'registryFile',
        registryFile.path,
        filename: registryFile.path.split('/').last,
      ),
    );

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // --- Product Functions ---
  // لم يعد الطلب يحتاج إلى إضافة الـ Header يدوياً، لأنه يتم إضافته في Request Modifier
  Future<Response> getProducts() => get('/products');

  Future<Response> createProduct(Map<String, dynamic> data, {File? image}) {
    final form = FormData(data);
    if (image != null) {
      form.files.add(MapEntry(
          'image', MultipartFile(image, filename: image.path.split('/').last)));
    }
    // يتم تمرير الـ Content-Type: multipart/form-data تلقائياً
    return post('/products', form);
  }

  Future<Response> updateProduct(String id, Map<String, dynamic> data, {File? image}) {
    final form = FormData(data);
    if (image != null) {
      form.files.add(MapEntry(
          'image', MultipartFile(image, filename: image.path.split('/').last)));
    }
    return patch('/products/$id', form);
  }

  Future<Response> deleteProduct(String id) => delete('/products/$id');

  // --- Chat Functions ---
  Future<Response> getMyChatThread() => get('/chat/my-thread');

  // --- Restaurant Functions ---
  Future<Response> getMyRestaurant() => get('/restaurants/my-restaurant');

  Future<Response> updateMyRestaurant(Map<String, dynamic> data) =>
      patch('/restaurants/my-restaurant', data);

  Future<Response> updateMyRestaurantWithLogo(Map<String, dynamic> data, File logoFile) async {
    final form = FormData({
      ...data,
      'logo': MultipartFile(logoFile, filename: 'logo.jpg'),
    });
    return patch('/restaurants/my-restaurant', form);
  }

  // --- Notifications Functions ---
  Future<Response> getMyNotifications() => get('/notifications/my-notifications');
  
  Future<Response> markNotificationAsRead(String id) => 
      patch('/notifications/$id/read', {});

  // ✨ دالة مساعدة لحفظ الـ Token
  void saveToken(String token) {
    _storage.write('token', token);
  }

  // ✨ دالة مساعدة لتسجيل الخروج بشكل كامل
  void logout() {
    _storage.remove('token');
    Get.offAllNamed(Routes.login);
  }

  // --- Services Functions ---
  Future<Response> requestService(Map<String, dynamic> data) =>
      post('/services/request', data);

  Future<Response> getMyServiceRequests() => get('/services/my-requests');

  // --- Orders Functions ---
  Future<Response> createOrder(Map<String, dynamic> data) =>
      post('/orders', data);

  Future<Response> getMyOrders() => get('/orders/my-orders');

  Future<Response> updateOrderStatus(String orderId, String status) =>
      patch('/orders/$orderId/status', {'status': status});

  // --- Chef Requests Functions ---
  Future<Response> createChefRequest(Map<String, dynamic> data) =>
      post('/chef-requests', data);

  Future<Response> getMyChefRequests() => get('/chef-requests/my-requests');

  Future<Response> updateChefRequestStatus(String requestId, String status) =>
      patch('/chef-requests/$requestId/status', {'status': status});

  // --- Documents Functions ---
  Future<Response> getMyDocuments() => get('/documents/my-documents');

  // --- Restaurants Functions (Additional) ---
  Future<Response> getAllRestaurants() => get('/restaurants');
}
