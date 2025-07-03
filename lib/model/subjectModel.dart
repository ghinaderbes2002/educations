import 'departmentModel.dart';
import 'userModel.dart';

class SubjectModel {
  final int subjectId;
  final String name;
  final int departmentId;
  final int academicYear;
  final int? doctorId;
  final UserModel? doctor;
  final DepartmentModel? department; // nullable الآن

  SubjectModel({
    required this.subjectId,
    required this.name,
    required this.departmentId,
    required this.academicYear,
    this.doctorId,
    this.doctor,
    this.department,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['subject_id'],
      name: json['name'],
      departmentId: json['department_id'],
      academicYear: json['academic_year'],
      doctorId: json['doctor_id'],
      doctor:
          json['doctor'] != null ? UserModel.fromJson(json['doctor']) : null,
      department: json['department'] != null
          ? DepartmentModel.fromJson(json['department'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'name': name,
      'department_id': departmentId,
      'academic_year': academicYear,
      'doctor_id': doctorId,
      'doctor': doctor?.toJson(),
      'department': department?.toJson(),
    };
  }
}
