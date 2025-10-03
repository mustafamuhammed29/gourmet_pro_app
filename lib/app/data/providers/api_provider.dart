import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class ApiProvider extends GetConnect {
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;

    httpClient.addRequestModifier<dynamic>((request) {
      final token = _storage.read('token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        _storage.remove('token');
        Get.offAllNamed(Routes.login);
      }
      return response;
    });
    super.onInit();
  }

  Future<Response> login(String email, String password) =>
      post('/auth/login', {'email': email, 'password': password});

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
        'licenseFile', // <-- اسم الحقل الصحيح
        licenseFile.path,
        filename: licenseFile.path.split('/').last,
      ),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'registryFile', // <-- اسم الحقل الصحيح
        registryFile.path,
        filename: registryFile.path.split('/').last,
      ),
    );

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // --- دوال المنتجات ---
  Future<Response> getProducts() => get('/products');

  Future<Response> createProduct(Map<String, dynamic> data, {File? image}) {
    final form = FormData(data);
    if (image != null) {
      form.files.add(MapEntry(
          'image', MultipartFile(image, filename: image.path.split('/').last)));
    }
    return post('/products', form);
  }

  // --- تم التعديل هنا ---
  Future<Response> updateProduct(String id, Map<String, dynamic> data, {File? image}) {
    final form = FormData(data);
    if (image != null) {
      form.files.add(MapEntry(
          'image', MultipartFile(image, filename: image.path.split('/').last)));
    }
    return patch('/products/$id', form);
  }

  // --- تم التعديل هنا ---
  Future<Response> deleteProduct(String id) => delete('/products/$id');
}

