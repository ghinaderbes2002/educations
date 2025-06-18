import 'package:eduction_system/controller/doctor/doctorController.dart';
import 'package:eduction_system/model/subjectModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DoctorExamsScreen extends StatelessWidget {
  final SubjectModel subject;

  const DoctorExamsScreen({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DoctorControllerImp>(
      init: DoctorControllerImp()..fetchExamsBySubjectId(subject.subjectId),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text("امتحانات ${subject.name}"),
          ),
          body: controller.isLoading
              ? Center(child: CircularProgressIndicator())
              : controller.exams.isEmpty
                  ? Center(child: Text("لا توجد امتحانات بعد."))
                  : ListView.builder(
                      itemCount: controller.exams.length,
                      itemBuilder: (context, index) {
                        final exam = controller.exams[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            title: Text(exam.title),
                            subtitle: Text(
                                "التاريخ: ${exam.date.toLocal().toString().split(' ')[0]}"),
                            trailing: Text("${exam.duration} دقيقة"),
                          ),
                        );
                      },
                    ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'إنشاء امتحان جديد',
            onPressed: () {
              // توجيه لشاشة إنشاء امتحان مع تمرير المادة
              // Get.to(() => CreateExamScreen(subject: subject));
            },
          ),
        );
      },
    );
  }
}
