import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/constants/api_constants.dart';

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

  Future<Response> registerAndUpload({
    required Map<String, String> data,
    required File licenseFile,
    required File registryFile,
  }) async {
    final form = FormData(data);

    form.files.add(MapEntry(
      'licenseFile',
      MultipartFile(licenseFile, filename: licenseFile.path.split('/').last),
    ));

    form.files.add(MapEntry(
      'registryFile',
      MultipartFile(registryFile, filename: registryFile.path.split('/').last),
    ));

    return post('/auth/register', form);
  }

  // --- Product Functions ---
  Future<Response> getProducts() => get('/products');

  Future<Response> createProduct(Map<String, dynamic> data, {File? image}) {
    final form = FormData(data);
    if (image != null) {
      form.files.add(MapEntry(
          'image', MultipartFile(image, filename: image.path.split('/').last)));
    }
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

  // --- ✨ AI Functions (Added) ---
  Future<Response> translateText(String text) =>
      post('/ai/translate', {'text': text});

  Future<Response> enhanceDescription(String description) =>
      post('/ai/enhance-description', {'description': description});

  Future<Response> generateReviewResponse(String review) =>
      post('/ai/generate-review-response', {'review': review});

  Future<Response> generateSocialPost(
      String dishName, String dishDescription) =>
      post('/ai/generate-social-post', {
        'dishName': dishName,
        'dishDescription': dishDescription,
      });
}

