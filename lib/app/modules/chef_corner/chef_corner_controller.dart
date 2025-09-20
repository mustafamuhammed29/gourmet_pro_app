import 'package:flutter/material.dart';
import 'package:get/get.dart';

// نموذج بيانات بسيط لتمثيل حالة طلبات الشيف
class ChefRequest {
  final String dishName;
  final String status; // e.g., 'قيد المراجعة', 'الوصفة مقترحة'

  ChefRequest({required this.dishName, required this.status});
}

class ChefCornerController extends GetxController {
  // متحكم في حقل إدخال المكونات
  final ingredientController = TextEditingController();

  // متغير لإدارة حالة التحميل (عند استدعاء AI)
  var isLoading = false.obs;

  // متغير لتخزين فكرة الطبق التي تم إنشاؤها بواسطة AI
  var aiDishIdea = ''.obs;

  // قائمة وهمية (dummy) لطلبات الشيف الحالية
  var myRequests = <ChefRequest>[].obs;

  @override
  void onInit() {
    super.onInit();
    // ملء القائمة ببيانات وهمية عند بدء تشغيل الـ Controller
    fetchMyRequests();
  }

  void fetchMyRequests() {
    // في تطبيق حقيقي، سيتم جلب هذه البيانات من الـ API
    myRequests.assignAll([
      ChefRequest(dishName: 'تارتار التونة الحار', status: 'قيد المراجعة'),
      ChefRequest(dishName: 'موس الشوكولاتة النباتي', status: 'الوصفة مقترحة'),
      ChefRequest(dishName: 'ريزوتو الفطر بالكمأة', status: 'مكتمل'),
    ]);
  }

  // دالة لاستدعاء AI والحصول على فكرة طبق
  Future<void> getDishIdea() async {
    final ingredient = ingredientController.text.trim();
    if (ingredient.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال مكون أساسي للحصول على فكرة.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    aiDishIdea.value = ''; // مسح النتيجة القديمة

    try {
      // محاكاة استدعاء API يستغرق ثانيتين
      await Future.delayed(const Duration(seconds: 2));

      // ملاحظة: في تطبيق حقيقي، سنقوم باستدعاء دالة من ApiProvider هنا
      // final result = await _apiProvider.generateDishIdea(ingredient);
      // aiDishIdea.value = result;

      // نتيجة وهمية للتجربة
      aiDishIdea.value =
      "<h4>دجاج بالليمون المعمر</h4><p>صدر دجاج متبل في الليمون المعمر والثوم والأعشاب، مشوي ببطء ويقدم فوق طبقة من الكسكس بالزعفران والمشمش المجفف، ومزين باللوز المحمص.</p>";
    } catch (e) {
      Get.snackbar(
        'خطأ في الشبكة',
        'حدث خطأ أثناء محاولة الحصول على فكرة، يرجى المحاولة مرة أخرى.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    ingredientController.dispose();
    super.onClose();
  }
}
