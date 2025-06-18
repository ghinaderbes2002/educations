class GradeModel {
  final String studentName;
  final String departmentName;
  final String subjectName;
  final double grade;
  final String status; // مثل: "promoted" أو "not_promoted"

  GradeModel({
    required this.studentName,
    required this.departmentName,
    required this.subjectName,
    required this.grade,
    required this.status,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      studentName: json['student_name'],
      departmentName: json['department_name'],
      subjectName: json['subject_name'],
      grade: (json['grade'] as num).toDouble(),
      status: json['status'],
    );
  }
}
