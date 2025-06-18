import 'package:eduction_system/controller/admin/SubjectController.dart';
import 'package:eduction_system/model/subjectModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditSubjectForm extends StatelessWidget {
  final SubjectControllerImp controller = Get.find<SubjectControllerImp>();

  EditSubjectForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: GetBuilder<SubjectController>(
          builder: (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "تعديل المادة",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),

              // اسم المادة
              TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: "اسم المادة",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // القسم
              DropdownButtonFormField(
                value: controller.selectedDepartment,
                decoration: const InputDecoration(
                  labelText: "القسم",
                  border: OutlineInputBorder(),
                ),
                items: controller.departments.map((dep) {
                  return DropdownMenuItem(
                    value: dep,
                    child: Text(dep.name),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectedDepartment = value;
                  controller.update();
                },
              ),
              const SizedBox(height: 16),

              // الدكتور
              DropdownButtonFormField(
                value: controller.selectedDoctor,
                decoration: const InputDecoration(
                  labelText: "الدكتور",
                  border: OutlineInputBorder(),
                ),
                items: controller.doctors.map((doc) {
                  return DropdownMenuItem(
                    value: doc,
                    child: Text(doc.username ?? ""),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectedDoctor = value;
                  controller.update();
                },
              ),
              const SizedBox(height: 24),

              // زر التعديل
              ElevatedButton(
                onPressed: () async {
                  if (controller.nameController.text.trim().isEmpty ||
                      controller.selectedDepartment == null ||
                      controller.selectedDoctor == null) {
                    Get.snackbar("خطأ", "يرجى تعبئة جميع الحقول");
                    return;
                  }

                  bool success = await controller.updateSubject(
                    SubjectModel(
                      subjectId: controller.currentEditingSubjectId!,
                      name: controller.nameController.text.trim(),
                      academicYear: 2, // عدل إذا لازم
                      departmentId: controller.selectedDepartment!.departmentId,
                      doctorId: controller.selectedDoctor!.user_id!,
                      department: controller.selectedDepartment!,
                    ),
                  );

                  if (success) {
                    controller.nameController.clear();
                    controller.selectedDepartment = null;
                    controller.selectedDoctor = null;
                    controller.currentEditingSubjectId = null;
                    controller.update();
                    Get.back(); // إغلاق النافذة
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  "تعديل المادة",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
