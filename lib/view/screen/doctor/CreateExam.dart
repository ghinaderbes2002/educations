import 'package:eduction_system/controller/doctor/CreateExamController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/model/subjectModel.dart';

class CreateExamScreen extends StatelessWidget {
  final SubjectModel subject;

  CreateExamScreen({Key? key, required this.subject}) : super(key: key);

  final CreateExamController controller = Get.put(CreateExamController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء سؤال لمادة ${subject.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: controller.questionController,
                decoration: InputDecoration(
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
              ...List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Obx(() => Row(
                        children: [
                          Radio<int>(
                            value: index,
                            groupValue: controller.correctAnswerIndex?.value,
                            onChanged: (value) {
                              controller.correctAnswerIndex?.value = value!;
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: controller.optionControllers[index],
                              decoration: InputDecoration(
                                labelText: 'الخيار ${index + 1}',
                                border: OutlineInputBorder(),
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
                      )),
                );
              }),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: controller.saveQuestion,
                child: Text('حفظ السؤال'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
