import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/models/product_model.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';

class ProductManagementController extends GetxController {
  // --- DEPENDENCIES ---
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // --- STATE FOR MANAGE MENU SCREEN ---
  final isLoading = true.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  // --- STATE FOR ADD/EDIT DISH SCREEN ---
  final isEditMode = false.obs;
  ProductModel? _editingProduct; // To hold the product being edited

  // Text Editing Controllers for the form
  late TextEditingController nameArController;
  late TextEditingController nameEnController;
  late TextEditingController descriptionArController;
  late TextEditingController descriptionEnController;
  late TextEditingController priceController;
  late TextEditingController categoryController;

  // Loading states for various actions on the form
  final isSaving = false.obs;
  final isTranslatingName = false.obs;
  final isTranslatingDescription = false.obs;
  final isEnhancingDescription = false.obs;

  // --- LIFECYCLE METHODS ---

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    fetchProducts();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  // --- PUBLIC METHODS for MANAGE MENU SCREEN ---

  /// Fetches the list of products from the API.
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      // THE FIX: We now handle the full Response object here.
      final response = await _apiProvider.getProducts();

      // Check the status code and ensure the body is a list before parsing.
      if (response.statusCode == 200 && response.body is List) {
        final List<dynamic> productJson = response.body;
        final productList = productJson
            .map((json) => ProductModel.fromJson(json))
            .toList();
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

  /// Navigates to the screen for adding a new dish.
  void goToAddDish() {
    Get.toNamed(Routes.addEditDish);
  }

  /// Navigates to the screen for editing an existing dish.
  void goToEditDish(ProductModel product) {
    Get.toNamed(Routes.addEditDish, arguments: product);
  }

  /// Navigates to the AI feature for generating social media posts.
  void goToSocialPostGenerator(ProductModel product) {
    Get.toNamed(Routes.socialPostGenerator, arguments: product);
  }

  // --- PUBLIC METHODS for ADD/EDIT DISH SCREEN ---

  /// Checks if arguments were passed to determine if we are in edit mode.
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

  /// Handles the save button press. Either creates a new dish or updates an existing one.
  Future<void> saveDish() async {
    try {
      isSaving.value = true;
      final Map<String, dynamic> dishData = {
        'name': nameArController.text,
        'description': descriptionArController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'category': categoryController.text,
        // 'imageUrl' would be handled after image upload implementation
      };

      if (isEditMode.value) {
        await _apiProvider.updateProduct(_editingProduct!.id, dishData);
      } else {
        await _apiProvider.createProduct(dishData);
      }

      await fetchProducts(); // Refresh the list
      Get.back(); // Go back to the manage menu screen
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

  /// Placeholder for image picking logic.
  void pickImage() {
    Get.snackbar('قيد التطوير', 'سيتم تفعيل ميزة رفع الصور قريباً.');
  }

  // --- AI Feature Simulation Methods ---

  Future<void> translateName() async {
    isTranslatingName.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
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

  // --- PRIVATE HELPER METHODS ---

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
    // Reset AI fields
    nameEnController.clear();
    descriptionEnController.clear();
  }

  void _clearFormFields() {
    nameArController.clear();
    nameEnController.clear();
    descriptionArController.clear();
    descriptionEnController.clear();
    priceController.clear();
    categoryController.clear();
  }
}
