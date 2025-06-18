class ReportModel {
  final String departmentName;
  final int totalStudents;
  final int passedStudents;
  final int failedStudents;

  ReportModel({
    required this.departmentName,
    required this.totalStudents,
    required this.passedStudents,
    required this.failedStudents,
  });
}
