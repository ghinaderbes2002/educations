import 'package:eduction_system/controller/admin/StudentsController.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/model/userModel.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StudentsControllerImp());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background, // خلفية رمادية فاتحة
      appBar: AppBar(
        title: const Text(
          'إدارة الطلاب',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColor.surface, // نص أبيض
          ),
        ),
        backgroundColor: AppColors.primary, // أزرق هادئ
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColor.surface),
            onPressed: () {
              // Get.find<StudentsControllerImp>()
              //     .fetchStudents(); // افتراض دالة لتحديث البيانات
            },
          ),
        ],
      ),
      body: GetBuilder<StudentsControllerImp>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // حقل اسم الطالب
              TextFormField(
                controller: controller.nameController,
                decoration: inputDecoration(
                  'اسم الطالب',
                  Icons.person,
                  isDarkMode,
                ),
              ),
              const SizedBox(height: 12),
              // حقل رقم الهاتف
              TextFormField(
                controller: controller.phoneController,
                decoration: inputDecoration(
                  'رقم الهاتف',
                  Icons.phone,
                  isDarkMode,
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              // حقل كلمة المرور
              TextFormField(
                controller: controller.passwordController,
                decoration: inputDecoration(
                  'كلمة المرور',
                  Icons.lock,
                  isDarkMode,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // زر إضافة أو تعديل
              ElevatedButton(
                onPressed: () {
                  controller.addStudent();
                  Get.snackbar(
                    controller.editingStudent == null
                        ? 'إضافة طالب'
                        : 'تعديل طالب',
                    controller.editingStudent == null
                        ? 'تمت إضافة الطالب بنجاح'
                        : 'تم تعديل الطالب بنجاح',
                    backgroundColor: AppColors.success,
                    colorText: AppColor.surface,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColor.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  controller.editingStudent == null
                      ? 'إضافة طالب'
                      : 'تعديل الطالب',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // قائمة الطلاب
              Expanded(
                child: controller.students.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 60,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا يوجد طلاب بعد',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.students.length,
                        itemBuilder: (context, index) {
                          UserModel student = controller.students[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            color: AppColor.surface, // خلفية بيضاء
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.1),
                                child: Text(
                                  student.username![0],
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                student.username!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                'رقم الهاتف: ${student.phone}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () {
                                      controller.updateStudent(student);
                                      Get.snackbar(
                                        'تعديل طالب',
                                        'جارٍ تحميل بيانات الطالب للتعديل',
                                        backgroundColor: AppColors.primary,
                                        colorText: AppColor.surface,
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppColors.error,
                                    ),
                                    onPressed: () {
                                      controller.deleteStudent(student.user_id!);
                                      Get.snackbar(
                                        'حذف طالب',
                                        'تم حذف الطالب بنجاح',
                                        backgroundColor: AppColors.error,
                                        colorText: AppColor.surface,
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    },
                                  ),
                                ],
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
    );
  }

  InputDecoration inputDecoration(
    String label,
    IconData icon,
    bool isDarkMode,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDarkMode ? AppColors.textSecondary : AppColors.textPrimary,
      ),
      prefixIcon: Icon(
        icon,
        color: AppColors.primary,
      ),
      filled: true,
      fillColor: isDarkMode
          ? AppColors.textPrimary.withOpacity(0.1)
          : AppColor.divider,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColor.primary,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColor.divider,
          width: 1,
        ),
      ),
    );
  }
}
