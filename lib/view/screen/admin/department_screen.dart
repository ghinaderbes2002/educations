import 'package:eduction_system/controller/admin/DepartmentController.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:eduction_system/view/widget/admin/DepartmentCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DepartmentControllerImp());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "إدارة الأقسام",
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
      body: GetBuilder<DepartmentControllerImp>(
        builder: (controller) => Container(
          color: AppColors.white,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    labelText: "اسم القسم",
                    hintText: "أدخل اسم القسم",
                    prefixIcon:
                        const Icon(Icons.category, color: AppColors.primary),
                    filled: true,
                    fillColor:   Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                ),
                const SizedBox(height: 16),
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                   onPressed: () {
                        final name = controller.nameController.text.trim();
                        if (name.isNotEmpty) {
                          controller.createDepartment(name: name);
                        } else {
                          Get.snackbar("تنبيه", "الرجاء إدخال اسم القسم");
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
                            "إضافة قسم",
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
            Expanded(
                  child: controller.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.departments.isEmpty
                          ? const Center(
                              child: Text(
                                "لا توجد أقسام حاليًا",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: controller.departments.length,
                              itemBuilder: (context, index) {
                                final dep = controller.departments[index];
                                return DepartmentCard(
                                  name: dep.name,
                                onEdit: () {
                                    String newName =
                                        dep.name; // البداية باسم القسم الحالي
                                    Get.defaultDialog(
                                      title: "تعديل القسم",
                                      content: TextFormField(
                                        initialValue: dep.name,
                                        autofocus: true,
                                        onChanged: (value) {
                                          newName = value;
                                        },
                                      ),
                                      textConfirm: "تعديل",
                                      textCancel: "إلغاء",
                                      onConfirm: () {
                                        if (newName.trim().isNotEmpty) {
                                          controller.updateDepartment(
                                              dep.departmentId, newName.trim());
                                          Get.back();
                                        } else {
                                          Get.snackbar(
                                              "خطأ", "يجب إدخال اسم صحيح");
                                        }
                                      },
                                    );
                                  },
                                 onDelete: () {
                                    Get.defaultDialog(
                                      title: "تأكيد الحذف",
                                      titleStyle: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                      middleText:
                                          "هل أنت متأكد من حذف قسم '${dep.name}'؟",
                                      middleTextStyle: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 16,
                                      ),
                                      textConfirm: "تأكيد",
                                      textCancel: "إلغاء",
                                      confirmTextColor: AppColors.white,
                                      cancelTextColor: AppColors.primary,
                                      buttonColor: AppColors.primary,
                                      radius: 12,
                                      onConfirm: () async {
                                        Get.back(); // أغلق النافذة أولاً
                                        await controller.deleteDepartment(
                                            dep.departmentId); // احذف القسم
                                        Get.snackbar(
                                          'تم الحذف',
                                          'تم حذف القسم ${dep.name} بنجاح',
                                          backgroundColor: AppColors.primary,
                                          colorText: AppColors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                      onCancel: () => Get.back(),
                                    );
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
