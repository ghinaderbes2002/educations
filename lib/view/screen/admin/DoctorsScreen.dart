import 'package:eduction_system/controller/admin/DoctorController.dart';
import 'package:eduction_system/model/userModel.dart';
import 'package:eduction_system/view/widget/admin/AddDoctorForm.dart';
import 'package:eduction_system/view/widget/admin/DoctorForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DoctorControllerImp controller = Get.put(DoctorControllerImp());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إدارة الدكاترة',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E3A59), // لون الـ AppBar
        elevation: 0,
      ),
      body: GetBuilder<DoctorControllerImp>(
        builder: (_) {
          if (controller.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2E3A59)));
          }
          if (controller.doctors.isEmpty) {
            return const Center(
              child: Text(
                'لا يوجد دكاترة حاليًا',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return Container(
            color: Colors.white, // خلفية بيضاء في الوضع الفاتح
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: controller.doctors.length,
              itemBuilder: (context, index) {
                UserModel doctor = controller.doctors[index];
                return AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      leading: CircleAvatar(
                        backgroundColor:
                            const Color(0xFF2E3A59).withOpacity(0.1),
                        child:
                            const Icon(Icons.person, color: Color(0xFF2E3A59)),
                      ),
                      title: Text(
                        doctor.username!,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      subtitle: Text(
                        doctor.phone!,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color(0xFF2E3A59)),
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'تعديل بيانات الدكتور',
                                titleStyle: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E3A59),
                                ),
                                content: DoctorForm(doctor: doctor),
                                radius: 16,
                              );
                            },
                            tooltip: 'تعديل الدكتور',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'تأكيد الحذف',
                                titleStyle: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E3A59),
                                ),
                                middleText:
                                    'هل أنت متأكد من حذف الدكتور ${doctor.username}؟',
                                middleTextStyle: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                ),
                                textCancel: 'إلغاء',
                                textConfirm: 'حذف',
                                confirmTextColor: Colors.white,
                                cancelTextColor: const Color(0xFF2E3A59),
                                buttonColor: const Color(0xFF2E3A59),
                                radius: 16,
                                onConfirm: () {
                                if (doctor.user_id != null) {
                                    controller.deleteDoctor(doctor.user_id!);
                                  } else {
                                    print("Error: doctor.id is null");
                                    // ممكن تعرض رسالة خطأ أو تتصرف بطريقة مناسبة
                                  }
                                  Get.back();
                                  Get.snackbar(
                                    'تم الحذف',
                                    'تم حذف الدكتور ${doctor.username} بنجاح',
                                    backgroundColor: const Color(0xFF2E3A59),
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                              );
                            },
                            tooltip: 'حذف الدكتور',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E3A59),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          Get.defaultDialog(
            title: 'إضافة دكتور جديد',
            titleStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3A59),
            ),
            content: AddDoctorForm(),
            radius: 16,
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
