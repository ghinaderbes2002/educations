import 'dart:io';
import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

class CreateExamController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController examDateController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  List<TextEditingController> optionControllers =
      List.generate(4, (_) => TextEditingController());

  int correctAnswerIndex = 0; // بدّل RxInt لـ int عادي

  String? examType;
  List<QuestionItem> questions = [];

  void addQuestion({
    required String questionText,
    required List<String> options,
    required int correctOptionIndex,
  }) {
    questions.add(QuestionItem(
      questionText: questionText,
      options: options,
      correctOptionIndex: correctOptionIndex,
    ));
    update(); // لازم تنادي update() لتحديث الواجهة عند التغيير
  }

  void clearQuestions() {
    questions.clear();
    update();
  }

  Future<void> saveExam(int subjectId) async {
    if (questions.isEmpty) {
      Get.snackbar("خطأ", "يجب إضافة سؤال واحد على الأقل");
      return;
    }
    if (examType == null || examType!.isEmpty) {
      Get.snackbar("خطأ", "يرجى اختيار نوع الامتحان");
      return;
    }
    final MyServices myServices = Get.find<MyServices>();
    final token = myServices.sharedPref.getString("token");
    if (token == null) {
      Get.snackbar("خطأ", "لم يتم العثور على التوكن");
      return;
    }
    String examDate = examDateController.text.trim();

    List<Map<String, dynamic>> questionsData = questions.map((q) {
      return {
        "question_text": q.questionText,
        "option1": q.options[0],
        "option2": q.options[1],
        "option3": q.options[2],
        "option4": q.options[3],
        "correct_option": q.correctOptionIndex + 1,
      };
    }).toList();

    Map<String, dynamic> data = {
      "subject_id": subjectId,
      "exam_date": examDate,
      "exam_type": examType,
      "questions": questionsData,
    };

    ApiClient apiClient = ApiClient();
    ApiResponse response = await apiClient.postData(
      url: '${ServerConfig().serverLink}/exams',
      data: data,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar("نجاح", "تم إنشاء الامتحان بنجاح");
      examDateController.clear();
      questionController.clear();
      for (var c in optionControllers) {
        c.clear();
      }
      correctAnswerIndex = 0;
      clearQuestions();
      examType = null;
      update();
    } else {
      print("فشل في الحفظ: ${response.statusCode} - ${response.data}");
      Get.snackbar("خطأ", "فشل في حفظ الامتحان: ${response.data}");
    }
  }

  Future<void> importExamFromExcel(int subjectId) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        print("📂 File path: $filePath");

        var bytes = File(filePath).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows.skip(1)) {
            String questionText = row[0]?.value.toString() ?? '';
            String option1 = row[1]?.value.toString() ?? '';
            String option2 = row[2]?.value.toString() ?? '';
            String option3 = row[3]?.value.toString() ?? '';
            String option4 = row[4]?.value.toString() ?? '';
            int correctOptionIndex =
                int.tryParse(row[5]?.value.toString() ?? '1')! - 1;

            if (questionText.isNotEmpty &&
                [option1, option2, option3, option4]
                    .every((o) => o.isNotEmpty)) {
              addQuestion(
                questionText: questionText,
                options: [option1, option2, option3, option4],
                correctOptionIndex: correctOptionIndex,
              );
            }
          }
        }

        update();
        Get.snackbar("نجاح", "تم استيراد الأسئلة من ملف Excel");
      } else {
        Get.snackbar("تنبيه", "لم يتم اختيار ملف");
      }
    } catch (e) {
      print("❌ Error importing exam: $e");
      Get.snackbar("خطأ", "فشل في استيراد الامتحان");
    }
  }
}

/// نموذج السؤال مع خياراته والإجابة الصحيحة
class QuestionItem {
  final String questionText;
  final List<String> options; // 4 خيارات دائماً
  final int correctOptionIndex; // رقم الخيار الصحيح (0-based)

  QuestionItem({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });
}
