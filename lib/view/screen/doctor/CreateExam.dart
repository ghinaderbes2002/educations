import 'package:eduction_system/controller/doctor/CreateExamController.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/model/subjectModel.dart';

class CreateExamScreen extends StatelessWidget {
  final SubjectModel subject;
  CreateExamScreen({Key? key, required this.subject}) : super(key: key);

  final CreateExamController controller = Get.put(CreateExamController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'إنشاء أسئلة لمادة ${subject.name}',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF2E3A59),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: ListView(
              children: [
              TextFormField(
                  controller: controller.examDateController,
                  readOnly: true, // يمنع الكتابة اليدوية
                  decoration: const InputDecoration(
                    labelText: 'تاريخ الامتحان (مثال: 2025-06-20)',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      // locale: const Locale(
                      //     "ar", "SA"), // اختياري إذا بدك التقويم بالعربي
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      controller.examDateController.text = formattedDate;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال تاريخ الامتحان';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.questionController,
                  decoration: const InputDecoration(
                    labelText: 'نص السؤال',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال نص السؤال';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                GetBuilder<CreateExamController>(
                  builder: (_) {
                    return Column(
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Radio<int>(
                                value: index,
                                groupValue: _.correctAnswerIndex,
                                onChanged: (value) {
                                  _.correctAnswerIndex = value!;
                                  _.update();
                                },
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _.optionControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'الخيار ${index + 1}',
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'يرجى إدخال نص الخيار';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 30),

                /// الأزرار الثلاثة ضمن صف منظم
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.formKey.currentState!.validate()) {
                            String questionText =
                                controller.questionController.text.trim();
                            List<String> options = controller.optionControllers
                                .map((c) => c.text.trim())
                                .toList();
                            int correctIndex = controller.correctAnswerIndex;

                            controller.addQuestion(
                              questionText: questionText,
                              options: options,
                              correctOptionIndex: correctIndex,
                            );

                            controller.questionController.clear();
                            for (var c in controller.optionControllers) {
                              c.clear();
                            }
                            controller.correctAnswerIndex = 0;
                            controller.update();

                            Get.snackbar("نجاح", "تم إضافة السؤال");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          " حفظ السؤال " ,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.importExamFromExcel(subject.subjectId!);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "إضافة من Excel",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.examDateController.text
                              .trim()
                              .isEmpty) {
                            Get.snackbar("خطأ", "يرجى إدخال تاريخ الامتحان");
                            return;
                          }
                          if (controller.questions.isEmpty) {
                            Get.snackbar(
                                "خطأ", "يرجى إضافة سؤال واحد على الأقل");
                            return;
                          }
                          Get.defaultDialog(
                            title: "اختر نوع الامتحان",
                            content: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    controller.examType = "theoretical";
                                    Get.back();
                                    controller.saveExam(subject.subjectId!);
                                  },
                                  child: const Text("نظري"),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.examType = "practical";
                                    Get.back();
                                    controller.saveExam(subject.subjectId!);
                                  },
                                  child: const Text("عملي"),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "إنهاء الاسئلة",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                GetBuilder<CreateExamController>(
                  builder: (_) {
                    if (_.questions.isEmpty) {
                      return const Center(
                        child: Text(
                          "لا توجد أسئلة مضافة بعد",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _.questions.length,
                      itemBuilder: (context, index) {
                        final q = _.questions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(q.questionText),
                            subtitle: Text(
                              q.options
                                  .asMap()
                                  .entries
                                  .map((e) =>
                                      "${e.key + 1}. ${e.value}${e.key == q.correctOptionIndex ? " ✔" : ""}")
                                  .join("\n"),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _.questions.removeAt(index);
                                _.update();
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
