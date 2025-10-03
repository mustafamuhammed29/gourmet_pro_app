import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';

class ReviewResponderController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // للتحكم في حقل إدخال تقييم الزبون
  final TextEditingController reviewInputController = TextEditingController();

  // متغير لمراقبة حالة التحميل (هل جاري إنشاء الرد؟)
  final RxBool isGenerating = false.obs;

  // متغير لمراقبة وتخزين الرد الذي تم إنشاؤه بواسطة الذكاء الاصطناعي
  final RxString aiResponse = ''.obs;

  // دالة لإنشاء رد على التقييم
  Future<void> generateReviewResponse() async {
    // التحقق من أن حقل الإدخال ليس فارغاً
    if (reviewInputController.text.trim().isEmpty) {
      Get.snackbar(
        'خطأ',
        'الرجاء إدخال تقييم الزبون أولاً.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isGenerating.value = true; // بدء التحميل
      aiResponse.value = ''; // إفراغ الرد القديم

      // --- استدعاء API حقيقي ---
      final response =
      await _apiProvider.generateReviewResponse(reviewInputController.text);
      if (response.isOk) {
        aiResponse.value = response.body['content'];
      } else {
        throw Exception('Failed to generate response');
      }
      // --- نهاية التعديل ---
    } catch (e) {
      // التعامل مع أي أخطاء قد تحدث أثناء الاتصال بالـ API
      Get.snackbar(
        'خطأ في الاتصال',
        'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isGenerating.value = false; // إيقاف التحميل في كل الحالات
    }
  }

  // يتم استدعاء هذه الدالة تلقائياً عند إغلاق الشاشة
  // لضمان تحرير الموارد وتجنب تسرب الذاكرة
  @override
  void onClose() {
    reviewInputController.dispose();
    super.onClose();
  }
}

