import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/constants/api_constants.dart';
import 'package:http/http.dart' as http;

// هذا الكلاس هو المسؤول الوحيد عن التواصل مع الخادم الخلفي
class ApiProvider extends GetConnect {
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;

    // معترض الطلبات: لإضافة بطاقة الدخول (Token) تلقائياً لكل طلب
    httpClient.addRequestModifier<dynamic>((request) {
      final token = _storage.read('authToken');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    // معترض الاستجابات: لمعالجة الأخطاء الشائعة
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        _storage.remove('authToken');
        Get.offAllNamed(Routes.login);
      }
      return response;
    });
    super.onInit();
  }

  // --- دوال المصادقة ---

  Future<Response> login(String email, String password) =>
      post('/auth/login', {'email': email, 'password': password});

  // دالة التسجيل الأساسية (للتوافق مع أي كود قديم)
  Future<Response> register(Map<String, dynamic> data) =>
      post('/auth/register', data);

  // دالة التسجيل المتكاملة (مع ملفات)
  Future<http.Response> registerAndUpload(
      Map<String, String> data, List<File> files) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/auth/register');
    final request = http.MultipartRequest('POST', uri);
    request.fields.addAll(data);
    for (var file in files) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          file.path,
          filename: file.path.split('/').last,
        ),
      );
    }
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // --- دوال إدارة المنتجات (التي كانت مفقودة) ---
  Future<Response> getProducts() => get('/products');
  Future<Response> createProduct(Map<String, dynamic> data) =>
      post('/products', data);
  Future<Response> updateProduct(String id, Map<String, dynamic> data) =>
      patch('/products/$id', data);
  Future<Response> deleteProduct(String id) => delete('/products/$id');
}

