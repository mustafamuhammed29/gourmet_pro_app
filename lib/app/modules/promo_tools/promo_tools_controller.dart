import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/models/product_model.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';

class PromoToolsController extends GetxController
    with StateMixin<List<ProductModel>> {
  // --- DEPENDENCIES ---
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // --- STATE ---
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxString restaurantName = 'مطعم الذواقة'.obs;

  // --- COMPUTED PROPERTIES ---
  String get digitalMenuUrl =>
      'https://my-gourmet-pro-menu.com/r/12345'; // Placeholder URL

  // --- LIFECYCLE METHODS ---
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // --- PUBLIC METHODS ---

  /// Fetches the product list and updates the UI state accordingly.
  Future<void> fetchProducts() async {
    change(null, status: RxStatus.loading());
    try {
      final response = await _apiProvider.getProducts();

      if (response.body is List) {
        final List<dynamic> productJson = response.body;
        final productList =
        productJson.map((json) => ProductModel.fromJson(json)).toList();

        products.assignAll(productList);

        if (productList.isEmpty) {
          change([], status: RxStatus.empty());
        } else {
          change(productList, status: RxStatus.success());
        }
      } else {
        throw Exception('Invalid data format received from server.');
      }
    } catch (e) {
      change(null, status: RxStatus.error('فشل في جلب المنتجات للقائمة'));
    }
  }

  /// Navigates to the digital menu preview screen.
  void previewDigitalMenu() {
    if (products.isNotEmpty) {
      Get.toNamed(Routes.digitalMenu);
    } else {
      CustomSnackbar.showInfo('لا توجد منتجات في قائمتك لعرضها.');
    }
  }

  /// Placeholder function for saving the QR code as an image.
  void saveQrCode() {
    CustomSnackbar.showSuccess('سيتم تفعيل ميزة حفظ الرمز قريباً.');
  }
}
