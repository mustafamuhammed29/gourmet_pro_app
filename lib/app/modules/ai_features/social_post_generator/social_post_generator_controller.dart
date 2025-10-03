import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/models/product_model.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';

class SocialPostGeneratorController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // متغير لمراقبة حالة التحميل
  final RxBool isGenerating = false.obs;

  // متغير لتخزين المنشور الذي تم إنشاؤه
  final RxString aiResponse = ''.obs;

  // متغير لتخزين بيانات الطبق الذي نعمل عليه
  // نستخدم Rx<ProductModel?> للسماح بوجود قيمة فارغة في البداية
  final Rx<ProductModel?> product = Rx<ProductModel?>(null);

  // هذه الدالة يتم استدعاؤها تلقائياً عند تهيئة الـ Controller
  @override
  void onInit() {
    super.onInit();
    // جلب بيانات الطبق التي تم تمريرها من الشاشة السابقة
    final arguments = Get.arguments;
    if (arguments is ProductModel) {
      product.value = arguments;
    }
  }

  // دالة لإنشاء منشور ترويجي
  Future<void> generateSocialPost() async {
    // التحقق من وجود بيانات الطبق أولاً
    if (product.value == null) {
      Get.snackbar('خطأ', 'لم يتم العثور على بيانات الطبق.');
      return;
    }

    try {
      isGenerating.value = true;
      aiResponse.value = ''; // إفراغ الرد القديم

      // --- استدعاء API حقيقي ---
      final response = await _apiProvider.generateSocialPost(
        product.value!.name,
        product.value!.description,
      );
      if (response.isOk) {
        aiResponse.value = response.body['content'];
      } else {
        throw Exception('Failed to generate post');
      }
      // --- نهاية التعديل ---
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء إنشاء المنشور.');
    } finally {
      isGenerating.value = false; // إيقاف التحميل
    }
  }
}

