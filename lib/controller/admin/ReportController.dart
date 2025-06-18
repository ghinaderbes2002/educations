import 'package:get/get.dart';

class ReportController extends GetxController {
  bool isLoading = true;

  List<StudentGradesReport> studentGrades = [];
  List<DepartmentTopStudents> topStudents = [];
  List<DoctorSuccessRate> doctorsSuccessRates = [];

  @override
  void onInit() {
    super.onInit();
    fetchAllReports();
  }

  void fetchAllReports() async {
    isLoading = true;
    update();

    // TODO: Replace these with actual API calls
    await Future.delayed(Duration(seconds: 1)); // Simulate loading

    studentGrades = [
      StudentGradesReport(name: "محمد خليل", grades: [95, 89, 82]),
      StudentGradesReport(name: "رنا الحسن", grades: [98, 93, 90]),
    ];

   topStudents = [
      DepartmentTopStudents(
        departmentName: " حواسيب",
        academicYear: 3,
        topStudents: [
          TopStudent(name: "رنا الحسن", average: 93.7),
          TopStudent(name: "محمد خليل", average: 88.6),
        ],
      ),
      DepartmentTopStudents(
        departmentName: " اتصالات",
        academicYear: 2,
        topStudents: [
          TopStudent(name: "نور عماد", average: 91.2),
          TopStudent(name: "وسيم العلي", average: 89.4),
        ],
      ),
    ];


    doctorsSuccessRates = [
      DoctorSuccessRate(name: "د. أحمد نعمان", successRate: 82),
      DoctorSuccessRate(name: "د. ليلى سليم", successRate: 91),
    ];

    isLoading = false;
    update();
  }
}

class StudentGradesReport {
  final String name;
  final List<double> grades;

  StudentGradesReport({required this.name, required this.grades});
}

class DepartmentTopStudents {
  final String departmentName;
  final int academicYear;
  final List<TopStudent> topStudents;

  DepartmentTopStudents({
    required this.departmentName,
    required this.academicYear,
    required this.topStudents,
  });
}

class TopStudent {
  final String name;
  final double average;

  TopStudent({
    required this.name,
    required this.average,
  });
}


class DoctorSuccessRate {
  final String name;
  final double successRate;

  DoctorSuccessRate({required this.name, required this.successRate});
}
