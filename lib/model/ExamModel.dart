import 'package:eduction_system/model/questionModel.dart';

class ExamModel {
  final int examId;
  final DateTime examDate;
  final String examType;
  final List<QuestionModel>? questions; // أضف هذا الحقل

  ExamModel({
    required this.examId,
    required this.examDate,
    required this.examType,
    this.questions,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    var questionsJson = json['questions'] as List<dynamic>?;

    return ExamModel(
      examId: json['exam_id'] ?? 0,
      examDate: DateTime.tryParse(json['exam_date'] ?? '') ?? DateTime.now(),
      examType: json['exam_type'] ?? 'unknown',
      questions: questionsJson != null
          ? questionsJson.map((q) => QuestionModel.fromJson(q)).toList()
          : null,
    );
  }
}
