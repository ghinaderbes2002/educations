import 'package:eduction_system/controller/students/StudentController.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:eduction_system/model/ExamModel.dart';
import 'package:eduction_system/model/studentAnswerModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TakeExamScreen extends StatefulWidget {
  final ExamModel exam;

  const TakeExamScreen({Key? key, required this.exam}) : super(key: key);

  @override
  State<TakeExamScreen> createState() => _TakeExamScreenState();
}

class _TakeExamScreenState extends State<TakeExamScreen>
    with WidgetsBindingObserver {
  final Map<int, int> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // يرسب الطالب إذا طلع التطبيق
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _failExam();
    }
  }

  Future<bool> _onWillPop() async {
    bool confirm = false;
    await Get.dialog(
      AlertDialog(
        title: const Text("تأكيد الانسحاب", textAlign: TextAlign.right),
        content: const Text(
          "هل أنت متأكد أنك تريد الانسحاب من الامتحان؟ سيتم اعتبارك راسبًا.",
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () {
              confirm = false;
              Get.back();
            },
            child: const Text("لا"),
          ),
          TextButton(
            onPressed: () {
              confirm = true;
              Get.back();
            },
            child: const Text("نعم"),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirm) {
      await _failExam();
      return false; // لا ترجع للخلف تلقائيًا، لأنه _failExam بيعمل Get.back()
    }

    return false; // إذا رفض، يبقى في الصفحة
  }

  Future<void> _failExam() async {
    final controller = Get.find<StudentControllerImp>();
    try {
      await controller
          .submitAnswers(widget.exam.examId, []); // إرسال بدون إجابات
    } catch (_) {}
    if (mounted) {
      Get.dialog(
        AlertDialog(
          title: const Text("تنبيه", textAlign: TextAlign.right),
          content: const Text("تم اعتبارك راسبًا لأنك خرجت من الامتحان",
              textAlign: TextAlign.right),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // إغلاق الـ dialog
                Get.back(); // الرجوع من صفحة الامتحان
              },
              child: const Text("رجوع"),
            )
          ],
        ),
        barrierDismissible: false, // تمنع إغلاق الـ dialog بالنقر خارجه
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final exam = widget.exam;

    if (exam.questions == null || exam.questions!.isEmpty) {
      return _buildEmptyExamScaffold();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("تقديم الامتحان",
                style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: AppColors.primary,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...exam.questions!.map(
                (q) => Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          q.questionText,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      ...List.generate(4, (index) {
                        int optionNumber = index + 1;
                        String optionText =
                            [q.option1, q.option2, q.option3, q.option4][index];

                        return RadioListTile<int>(
                          title: Text(optionText, textAlign: TextAlign.right),
                          value: optionNumber,
                          groupValue: selectedAnswers[q.questionId],
                          onChanged: (value) {
                            setState(() {
                              selectedAnswers[q.questionId] = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.trailing,
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final answers = selectedAnswers.entries
                      .map((e) => studentAnswerModel(
                          questionId: e.key, selectedOption: e.value))
                      .toList();

                  try {
                    final controller = Get.find<StudentControllerImp>();
                    int score =
                        await controller.submitAnswers(exam.examId, answers) ??
                            0;

                    Get.dialog(AlertDialog(
                      title:
                          const Text("تم التقديم", textAlign: TextAlign.right),
                      content:
                          Text("علامتك: $score", textAlign: TextAlign.right),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("رجوع"),
                        )
                      ],
                    ));
                  } catch (e) {
                    if (e.toString().contains("400")) {
                      Get.snackbar(
                        "تنبيه",
                        "لقد قدمت هذا الامتحان مسبقًا.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orange.shade200,
                        colorText: Colors.black,
                      );
                    } else {
                      Get.snackbar(
                        "خطأ",
                        "حدث خطأ أثناء إرسال الإجابات",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.shade200,
                        colorText: Colors.white,
                      );
                    }
                  }
                },
                child: const Text("تم"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyExamScaffold() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تقديم الامتحان",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: AppColors.primary,
        ),
        body: const Center(child: Text("لا توجد أسئلة في هذا الامتحان")),
      ),
    );
  }
}
