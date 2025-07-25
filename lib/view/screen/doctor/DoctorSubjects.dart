import 'package:eduction_system/controller/auth/signUp_controller.dart';
import 'package:eduction_system/core/constant/App_routes.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:eduction_system/view/screen/doctor/DoctorExams.dart';
import 'package:eduction_system/view/screen/doctor/DoctorInboxScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/controller/doctor/doctorController.dart';

class DoctorSubjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<DoctorsControllerImp>(
        init: DoctorsControllerImp(),
        builder: (controller) {
          if (controller.isLoading) {
            return Scaffold(
              appBar: buildAppBar(),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (controller.subjects.isEmpty) {
            return Scaffold(
              appBar: buildAppBar(),
              body: Center(child: Text("لا توجد مواد مرتبطة بك.")),
            );
          }

          return Scaffold(
            appBar: buildAppBar(),
            body: ListView.builder(
              itemCount: controller.subjects.length,
              itemBuilder: (context, index) {
                final subject = controller.subjects[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    title: Text(subject.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      "السنة: ${subject.academicYear}   |   القسم: ${subject.department?.name}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Icon(Icons.arrow_back_ios_new),
                    onTap: () {
                      Get.to(() => DoctorExamsScreen(subject: subject));
                      print("تم الضغط على المادة: ${subject.name}");
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        "المواد الدراسية",
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
      actions: [
        IconButton(
          icon: Icon(Icons.mail_outline, color: Colors.white),
          tooltip: "الرسائل الواردة",
          onPressed: () {
            Get.to(() => DoctorInboxScreen());
          },
        ),
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
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
    );
  }
}
