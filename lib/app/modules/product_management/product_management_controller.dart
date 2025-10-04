import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/models/product_model.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart'; // ✨ ١. استيراد المكتبة

class ProductManagementController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final ImagePicker _picker = ImagePicker(); // ✨ ٢. إنشاء نسخة من المكتبة

  final isLoading = true.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  final isEditMode = false.obs;
  ProductModel? _editingProduct;

  late TextEditingController nameArController;
  late TextEditingController nameEnController;
  late TextEditingController descriptionArController;
  late TextEditingController descriptionEnController;
  late TextEditingController priceController;
  late TextEditingController categoryController;

  final isSaving = false.obs;
  final isTranslatingName = false.obs;
  final isTranslatingDescription = false.obs;
  final isEnhancingDescription = false.obs;

  final Rx<File?> pickedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getProducts();

      if (response.isOk && response.body is List) {
        final List<dynamic> productJson = response.body;
        final productList =
        productJson.map((json) => ProductModel.fromJson(json)).toList();
        products.assignAll(productList);
      } else {
        throw Exception('Failed to parse products from server response.');
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في جلب قائمة الطعام. حاول مرة أخرى.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToAddDish() {
    _clearFormFields();
    isEditMode.value = false;
    _editingProduct = null;
    Get.toNamed(Routes.addEditDish);
  }

  void goToEditDish(ProductModel product) {
    _populateFormFields(product);
    isEditMode.value = true;
    _editingProduct = product;
    Get.toNamed(Routes.addEditDish, arguments: product);
  }

  void goToSocialPostGenerator(ProductModel product) {
    Get.toNamed(Routes.socialPostGenerator, arguments: product);
  }

  void checkEditingMode() {
    if (Get.arguments != null && Get.arguments is ProductModel) {
      isEditMode.value = true;
      _editingProduct = Get.arguments as ProductModel;
      _populateFormFields(_editingProduct!);
    } else {
      isEditMode.value = false;
      _editingProduct = null;
      _clearFormFields();
    }
  }

  Future<void> saveDish() async {
    try {
      isSaving.value = true;
      final dishData = {
        'name': nameArController.text,
        'description': descriptionArController.text,
        'price': priceController.text, // الإرسال كنص أفضل
        'category': categoryController.text,
      };

      if (isEditMode.value) {
        await _apiProvider.updateProduct(_editingProduct!.id.toString(), dishData,
            image: pickedImage.value);
      } else {
        await _apiProvider.createProduct(dishData, image: pickedImage.value);
      }

      await fetchProducts();
      Get.back();
      Get.snackbar(
        'نجاح',
        isEditMode.value ? 'تم تحديث الطبق بنجاح!' : 'تم إضافة الطبق بنجاح!',
        backgroundColor: AppColors.accent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حفظ الطبق. يرجى التأكد من البيانات.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // ✨ ٣. تفعيل دالة اختيار الصور
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في اختيار الصورة.');
    }
  }

  Future<void> translateName() async {
    isTranslatingName.value = true;
    await Future.delayed(const Duration(seconds: 1));
    nameEnController.text = "Grilled Salmon (Translated)";
    isTranslatingName.value = false;
  }

  Future<void> translateDescription() async {
    isTranslatingDescription.value = true;
    await Future.delayed(const Duration(seconds: 1));
    descriptionEnController.text =
    "A short and appealing description... (Translated)";
    isTranslatingDescription.value = false;
  }

  Future<void> enhanceDescription() async {
    isEnhancingDescription.value = true;
    await Future.delayed(const Duration(seconds: 2));
    descriptionArController.text =
    "${descriptionArController.text} (وصف محسن ومميز لجذب الزبائن).";
    isEnhancingDescription.value = false;
  }

  void _initializeControllers() {
    nameArController = TextEditingController();
    nameEnController = TextEditingController();
    descriptionArController = TextEditingController();
    descriptionEnController = TextEditingController();
    priceController = TextEditingController();
    categoryController = TextEditingController();
  }

  void _disposeControllers() {
    nameArController.dispose();
    nameEnController.dispose();
    descriptionArController.dispose();
    descriptionEnController.dispose();
    priceController.dispose();
    categoryController.dispose();
  }

  void _populateFormFields(ProductModel product) {
    nameArController.text = product.name;
    descriptionArController.text = product.description;
    priceController.text = product.price.toString();
    categoryController.text = product.category;
    nameEnController.clear();
    descriptionEnController.clear();
    pickedImage.value = null;
  }

  void _clearFormFields() {
    nameArController.clear();
    nameEnController.clear();
    descriptionArController.clear();
    descriptionEnController.clear();
    priceController.clear();
    categoryController.clear();
    pickedImage.value = null;
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }
}
