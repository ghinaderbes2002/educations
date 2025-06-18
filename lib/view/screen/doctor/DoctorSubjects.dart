import 'package:eduction_system/core/them/app_colors.dart';
import 'package:eduction_system/view/screen/doctor/DoctorExams.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/controller/doctor/doctorController.dart';

class DoctorSubjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<DoctorControllerImp>(
        init: DoctorControllerImp(),
        builder: (controller) {
          if (controller.isLoading) {
            return Scaffold(
              appBar:  AppBar(
                title: const Text(
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
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (controller.subjects.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: Text("موادي الدراسية")),
              body: Center(child: Text("لا توجد مواد مرتبطة بك.")),
            );
          }

          return Scaffold(
            appBar: AppBar(title: Text("موادي الدراسية")),
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
                      "السنة: ${subject.academicYear}   |   القسم: ${subject.department.name}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Icon(Icons.arrow_back_ios_new), // سهم لليمين
                    onTap: () {
                      // ✅ توجيه لصفحة ثانية مع تمرير المادة كموديل أو ID
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
}
