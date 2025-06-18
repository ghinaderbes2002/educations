import 'package:eduction_system/model/gradeModel.dart';
import 'package:get/get.dart';

class GradesController extends GetxController {
  
  List<GradeModel> grades = [];
  bool isLoading = false;

  @override
  void onInit() {
    fetchGrades();
    super.onInit();
  }

  void fetchGrades() async {
    isLoading = true;
    update(); // حدث الواجهة

    // بيانات وهمية بدل جلب من API
    await Future.delayed(Duration(seconds: 2)); // محاكاة انتظار

    grades = [
      GradeModel(
        studentName: "أحمد العلي",
        departmentName: "هندسة حواسيب",
        subjectName: "شبكات 1",
        grade: 75,
        status: "promoted",
      ),
      GradeModel(
        studentName: "سارة محمد",
        departmentName: "هندسة قيادة",
        subjectName: "كهرباء دوائر",
        grade: 60,
        status: "promoted",
      ),
      GradeModel(
        studentName: "خالد يوسف",
        departmentName: "هندسة اتصالات ",
        subjectName: "برمجة 2",
        grade: 45,
        status: "not_promoted",
      ),
    ];

    isLoading = false;
    update(); // حدث الواجهة بعد تعبئة البيانات
  }
}
