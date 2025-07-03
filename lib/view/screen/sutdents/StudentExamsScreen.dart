import 'package:eduction_system/controller/students/StudentController.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:eduction_system/model/subjectModel.dart';
import 'package:eduction_system/view/screen/sutdents/TakeExamScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentExamsScreen extends StatelessWidget {
  final SubjectModel subject;

  const StudentExamsScreen({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentControllerImp());

    Future.microtask(() => controller.fetchExamDetailsById(subject.subjectId));

    return GetBuilder<StudentControllerImp>(
      builder: (controller) {
        return Scaffold(
          appBar:  AppBar(
            title: Text(
              " امتحانات مادة ${subject.name} ",
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
          
          
        
          body: controller.isLoading
              ? Center(child: CircularProgressIndicator())
              : controller.exams.isEmpty
                  ? Center(child: Text("لا توجد امتحانات بعد"))
                  : ListView.builder(
                      padding: EdgeInsets.all(12),
                      itemCount: controller.exams.length,
                      itemBuilder: (context, index) {
                        final exam = controller.exams[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            title: Text(
                              "امتحان ${exam.examType}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              "التاريخ: ${exam.examDate.toLocal().toString().split(' ')[0]}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Get.to(() => TakeExamScreen(exam: exam));
                            },
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
