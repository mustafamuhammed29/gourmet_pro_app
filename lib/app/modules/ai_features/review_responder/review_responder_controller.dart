import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewResponderController extends GetxController {
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

      // --- محاكاة استدعاء API ---
      // في التطبيق الحقيقي، سنستدعي هنا دالة من ApiProvider
      // final response = await _apiProvider.generateAiResponse(reviewInputController.text);
      // aiResponse.value = response;
      await Future.delayed(const Duration(seconds: 2)); // انتظار وهمي
      aiResponse.value =
      'شكراً جزيلاً لك على كلماتك الرائعة! يسعدنا جداً أنك استمتعت بالطعام والخدمة. فريقنا يعمل بجد لتقديم أفضل تجربة ممكنة، ورضاكم هو أكبر تقدير لنا. نتطلع لزيارتك مرة أخرى قريباً!';
      // --- نهاية المحاكاة ---

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
