import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateExamController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers =
      List.generate(4, (_) => TextEditingController());

  RxInt? correctAnswerIndex = RxInt(-1);

  @override
  void onClose() {
    questionController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  bool validate() {
    if (formKey.currentState?.validate() != true) return false;
    if (correctAnswerIndex?.value == -1) {
      Get.snackbar('خطأ', 'يرجى اختيار الإجابة الصحيحة');
      return false;
    }
    return true;
  }

  void saveQuestion() {
    if (!validate()) return;

    String questionText = questionController.text.trim();
    List<String> options = optionControllers.map((c) => c.text.trim()).toList();
    int correctIndex = correctAnswerIndex!.value;

    print('سؤال: $questionText');
    print('خيارات: $options');
    print('الإجابة الصحيحة: الخيار رقم ${correctIndex + 1}');

    // أرسل البيانات لل API أو خزنها محلياً حسب الحاجة

    Get.back();
    Get.snackbar('تم', 'تم حفظ السؤال بنجاح');
  }
}
