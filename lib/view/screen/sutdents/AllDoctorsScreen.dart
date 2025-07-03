import 'package:eduction_system/controller/admin/DoctorController.dart';
import 'package:eduction_system/controller/students/StudentController.dart';
import 'package:eduction_system/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/core/them/app_colors.dart';

class AllDoctorsScreen extends StatelessWidget {
  const AllDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorControllerImp());
    controller.fetchDoctors();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "قائمة الدكاترة",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: 'Cairo',
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
        ),
        body: GetBuilder<DoctorControllerImp>(
          builder: (controller) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.doctors.isEmpty) {
              return const Center(child: Text("لا يوجد دكاترة."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.doctors.length,
              itemBuilder: (context, index) {
                UserModel doctor = controller.doctors[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      doctor.username ?? 'دكتور بدون اسم',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      doctor.role ?? 'دكتور',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      final TextEditingController messageController =
                          TextEditingController();

                      Get.defaultDialog(
                        title: "إرسال رسالة",
                        content: Column(
                          children: [
                            Text(
                                "أرسل رسالة إلى: ${doctor.username ?? 'دكتور'}"),
                            const SizedBox(height: 12),
                            TextField(
                              controller: messageController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: "اكتب رسالتك هنا...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.send),
                              label: const Text("إرسال"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              onPressed: () async {
                                final messageText =
                                    messageController.text.trim();
                                if (messageText.isEmpty) {
                                  Get.snackbar("تنبيه", "يرجى كتابة الرسالة");
                                  return;
                                }

                                // استدعاء الدالة الموجودة بمكان ثاني
                                final studentController =
                                    Get.find<StudentControllerImp>();
                                // await studentController.sendMessageToDoctor(
                                //   doctorId: doctor.id!,
                                //   messageText: messageText,
                                // );

                                Get.back(); // إغلاق الحوار بعد الإرسال
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
