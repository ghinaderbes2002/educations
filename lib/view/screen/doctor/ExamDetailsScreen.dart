import 'package:eduction_system/core/them/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/controller/doctor/doctorController.dart';
import 'package:eduction_system/model/ExamModel.dart';
import 'package:eduction_system/model/questionModel.dart';
import 'package:collection/collection.dart'; // لاستعمال firstWhereOrNull

class ExamDetailsScreen extends StatelessWidget {
  final int examId;

  const ExamDetailsScreen({Key? key, required this.examId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorsControllerImp>();

    // إيجاد الامتحان من القائمة
    final exam = controller.exams.firstWhereOrNull((e) => e.examId == examId);

    if (exam == null) {
      return Scaffold(
        appBar: AppBar(
            title: const Text("تفاصيل الامتحان",
                textDirection: TextDirection.rtl)),
        body: const Center(
            child:
                Text("الامتحان غير موجود", textDirection: TextDirection.rtl)),
      );
    }

    final List<QuestionModel> questions = exam.questions ?? [];

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            " تفاصيل الامتحان",
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: AppColors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          elevation: 4,
        ),
        
        body: const Center(
            child:
                Text("لا توجد أسئلة للعرض", textDirection: TextDirection.rtl)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          " تفاصيل الامتحان",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final question = questions[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                title: Text(
                  question.questionText,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("1) ${question.option1}",
                        textDirection: TextDirection.rtl),
                    Text("2) ${question.option2}",
                        textDirection: TextDirection.rtl),
                    Text("3) ${question.option3}",
                        textDirection: TextDirection.rtl),
                    Text("4) ${question.option4}",
                        textDirection: TextDirection.rtl),
                    const SizedBox(height: 4),
                    Text(
                      "✅ الإجابة الصحيحة: الخيار ${question.correctOption}",
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
