import 'package:eduction_system/controller/auth/signUp_controller.dart';
import 'package:eduction_system/controller/students/StudentController.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:eduction_system/core/constant/App_routes.dart';
import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:eduction_system/view/screen/sutdents/StudentExamsScreen.dart';
import 'package:eduction_system/view/screen/sutdents/StudentGradesScreen.dart';
import 'package:eduction_system/view/screen/sutdents/StudentInboxScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentSubjectsScreen extends StatelessWidget {
  const StudentSubjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentControllerImp());
    controller.fetchSubjectsByStudent();

    TextEditingController messageController = TextEditingController();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<StudentControllerImp>(
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "المواد الدراسية ",
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
              leading: IconButton(
                icon: const Icon(Icons.grade, color: Colors.white),
                tooltip: "${ServerConfig().serverLink}",
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final myServices = Get.find<MyServices>();
                  int? userId = myServices.sharedPref.getInt('userId');
                  final academicYear = prefs.getInt('academicYear') ?? 1;

                  if (userId != 0 && userId != null) {
                    Get.to(() => StudentGradesScreen(
                        studentId: userId, academicYear: academicYear));
                  } else {
                    Get.snackbar(
                      "خطأ",
                      "لم يتم العثور على معرف الطالب.",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
              actions: [
                IconButton(
                  icon:
                      const Icon(Icons.mark_email_unread, color: Colors.white),
                  tooltip: "رسائل الدكتور",
                  onPressed: () {
                    Get.to(() => StudentInboxScreen());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: "تسجيل الخروج",
                  onPressed: () async {
                    bool? confirm = await Get.defaultDialog<bool>(
                      title: "تأكيد",
                      middleText: "هل أنت متأكد أنك تريد تسجيل الخروج؟",
                      textConfirm: "نعم",
                      textCancel: "لا",
                      onConfirm: () => Get.back(result: true),
                      onCancel: () => Get.back(result: false),
                    );

                    if (confirm == true) {
                      await Get.put(SignUpControllerImp()).logout();
                      Get.offAllNamed(AppRoute.onBoarding);
                    }
                  },
                ),
              ],
            ),
            body: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.subjects.length,
                          itemBuilder: (context, index) {
                            final subject = controller.subjects[index];
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                title: Text(
                                  subject.name,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.message,
                                          color: Colors.green),
                                      tooltip: "إرسال رسالة للدكتور",
                                      onPressed: () {
                                        messageController.clear();
                                        Get.defaultDialog(
                                          title: "إرسال رسالة للدكتور",
                                          content: TextField(
                                            controller: messageController,
                                            maxLines: 4,
                                            decoration: const InputDecoration(
                                              hintText: "اكتب رسالتك هنا",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          textConfirm: "إرسال",
                                          textCancel: "إلغاء",
                                          onConfirm: () {
                                            final text =
                                                messageController.text.trim();
                                            if (text.isEmpty) {
                                              Get.snackbar(
                                                  "خطأ", "يرجى كتابة رسالة");
                                              return;
                                            }

                                            final myServices =
                                                Get.find<MyServices>();
                                            int? studentId = myServices
                                                .sharedPref
                                                .getInt('userId');
                                            print(
                                                'جلبت معرف الطالب: $studentId');

                                            if (studentId == null) {
                                              Get.snackbar('خطأ',
                                                  'لم يتم العثور على معرف الطالب');
                                              return;
                                            }

                                            if (subject.doctorId != null) {
                                              controller
                                                  .sendMessageToDoctorDirect(
                                                studentId: studentId,
                                                doctorId: subject.doctorId!,
                                                messageText: text,
                                              );
                                              Get.back();
                                              Get.snackbar("تم الإرسال",
                                                  "تم إرسال الرسالة بنجاح");
                                            } else {
                                              Get.snackbar('تنبيه',
                                                  'لا يوجد دكتور مرتبط بهذه المادة');
                                            }
                                          },
                                          onCancel: () => Get.back(),
                                        );
                                      },
                                    ),
                                    const Icon(Icons.arrow_back_ios),
                                  ],
                                ),
                                onTap: () {
                                  Get.to(() =>
                                      StudentExamsScreen(subject: subject));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
