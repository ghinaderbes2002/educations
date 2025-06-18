import 'package:eduction_system/controller/admin/SubjectController.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:eduction_system/model/departmentModel.dart';
import 'package:eduction_system/model/subjectModel.dart';
import 'package:eduction_system/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SubjectControllerImp());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "إدارة المواد",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 4,
        centerTitle: true,
      ),
      body: GetBuilder<SubjectControllerImp>(
        builder: (controller) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: controller.nameController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: "اسم المادة",
                      hintText: "أدخل اسم المادة",
                      prefixIcon:
                          const Icon(Icons.book, color: AppColors.primary),
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // القسم
                  DropdownButtonFormField<DepartmentModel>(
                    value: controller.selectedDepartment,
                    decoration: InputDecoration(
                      labelText: "القسم",
                      prefixIcon:
                          const Icon(Icons.category, color: AppColors.primary),
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                    ),
                    items: controller.departments.map((dep) {
                      return DropdownMenuItem<DepartmentModel>(
                        value: dep,
                        child: Text(
                          dep.name,
                          style: const TextStyle(
                              fontFamily: 'Cairo', fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: controller.setSelectedDepartment,
                    validator: (val) {
                      if (val == null) return "يرجى اختيار القسم";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // الدكتور
                  DropdownButtonFormField<UserModel>(
                    value: controller.selectedDoctor,
                    decoration: InputDecoration(
                      labelText: "الدكتور",
                      prefixIcon:
                          const Icon(Icons.person, color: AppColors.primary),
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                    ),
                    items: controller.doctors.map((doc) {
                      return DropdownMenuItem<UserModel>(
                        value: doc,
                        child: Text(
                          doc.username ?? '',
                          style: const TextStyle(
                              fontFamily: 'Cairo', fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: controller.setSelectedDoctor,
                    validator: (val) {
                      if (val == null) return "يرجى اختيار الدكتور";
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // زر الإضافة
                  Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (controller.nameController.text.trim().isEmpty ||
                              controller.selectedDepartment == null ||
                              controller.selectedDoctor == null) {
                            Get.snackbar("خطأ",
                                "يرجى إدخال اسم المادة واختيار القسم والدكتور");
                            return;
                          }
                          bool success = await controller.createSubject(
                            name: controller.nameController.text.trim(),
                            academicYear: 2,
                            departmentId:
                                controller.selectedDepartment!.departmentId,
                            doctorId: controller.selectedDoctor!.user_id!,
                          );

                          if (success) {
                            controller.nameController.clear();
                            controller.selectedDepartment = null;
                            controller.selectedDoctor = null;
                            controller.update();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_circle, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "إضافة مادة",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // قائمة المواد
                  Expanded(
                    child: controller.subjects.isEmpty
                        ? const Center(
                            child: Text(
                              "لا توجد مواد حاليًا",
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18,
                                  color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.subjects.length,
                            itemBuilder: (context, index) {
                              final subject = controller.subjects[index];
                              return AnimatedOpacity(
                                opacity: 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    leading: CircleAvatar(
                                      backgroundColor: AppColors.primary,
                                      child: Text(
                                        subject.name[0],
                                        style: const TextStyle(
                                            color: AppColors.white),
                                      ),
                                    ),
                                    title: Text(
                                      subject.name,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "القسم: ${subject.department?.name ?? '---'}\nالدكتور: ${subject.doctor?.username ?? '---'}",
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: AppColors.primary),
                                          tooltip: "تعديل المادة",
                                          onPressed: () {
                                            String newName = subject.name;
                                            UserModel? selectedDoctor =
                                                subject.doctor;
                                            int? selectedDoctorId =
                                                subject.doctor?.user_id;

                                            Get.defaultDialog(
                                              title: "تعديل اسم المادة",
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    initialValue: newName,
                                                    autofocus: true,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                "اسم المادة"),
                                                    onChanged: (value) =>
                                                        newName = value,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  DropdownButtonFormField<int>(
                                                    value: selectedDoctorId,
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            "الدكتور المسؤول"),
                                                    items: controller.doctors
                                                        .map((doctor) {
                                                      return DropdownMenuItem<
                                                          int>(
                                                        value: doctor.user_id,
                                                        child: Text(
                                                            doctor.username ??
                                                                "بدون اسم"),
                                                      );
                                                    }).toList(),
                                                    onChanged: (doctorId) {
                                                      selectedDoctorId =
                                                          doctorId; // Update local variable
                                                      selectedDoctor =
                                                          controller.doctors
                                                              .firstWhere(
                                                        (doc) =>
                                                            doc.user_id ==
                                                            doctorId,
                                                        orElse: () =>
                                                            UserModel(), // Provide a default if not found
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                              textConfirm: "تعديل",
                                              textCancel: "إلغاء",
                                              onConfirm: () {
                                                if (newName.trim().isEmpty ||
                                                    selectedDoctorId == null) {
                                                  Get.snackbar("خطأ",
                                                      "يرجى إدخال اسم المادة واختيار الدكتور");
                                                  return;
                                                }

                                                SubjectModel updatedSubject =
                                                    SubjectModel(
                                                  subjectId: subject.subjectId,
                                                  name: newName.trim(),
                                                  department:
                                                      subject.department,
                                                  departmentId:
                                                      subject.departmentId,
                                                  academicYear:
                                                      subject.academicYear,
                                                  doctorId:
                                                      selectedDoctorId!, // Use the local variable
                                                  doctor: selectedDoctor,
                                                );

                                                controller.updateSubject(
                                                    updatedSubject);
                                                Get.back();
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            Get.defaultDialog(
                                              title: "تأكيد الحذف",
                                              titleStyle: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                              middleText:
                                                  "هل أنت متأكد من حذف مادة '${subject.name}'؟",
                                              middleTextStyle: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 16,
                                              ),
                                              textConfirm: "تأكيد",
                                              textCancel: "إلغاء",
                                              confirmTextColor: AppColors.white,
                                              cancelTextColor:
                                                  AppColors.primary,
                                              buttonColor: AppColors.primary,
                                              radius: 12,
                                              onConfirm: () {
                                                controller.deleteSubject(
                                                    subject.subjectId);
                                                Get.back();
                                                Get.snackbar(
                                                  'تم الحذف',
                                                  'تم حذف المادة ${subject.name} بنجاح',
                                                  backgroundColor:
                                                      AppColors.primary,
                                                  colorText: AppColors.white,
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                );
                                              },
                                              onCancel: () => Get.back(),
                                            );
                                          },
                                          tooltip: "حذف المادة",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
