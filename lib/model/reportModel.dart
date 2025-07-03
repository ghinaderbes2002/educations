
class SubjectScore {
  final String subjectName;
  final double score;
  final String promotionStatus;
  final int examId;
  final int subjectId;
  final bool examExists;
  final bool subjectExists;
  final ResultData? resultData;

  SubjectScore({
    required this.subjectName,
    required this.score,
    required this.promotionStatus,
    required this.examId,
    required this.subjectId,
    required this.examExists,
    required this.subjectExists,
    this.resultData,
  });

  factory SubjectScore.fromJson(Map<String, dynamic> json) {
    return SubjectScore(
      subjectName: json['subjectName'],
      score: (json['score'] as num).toDouble(),
      promotionStatus: json['promotionStatus'],
      examId: json['examId'],
      subjectId: json['subjectId'],
      examExists: json['examExists'],
      subjectExists: json['subjectExists'],
      resultData: json['resultData'] != null
          ? ResultData.fromJson(json['resultData'])
          : null,
    );
  }
}

class ResultData {
  final int studentId;
  final int examId;

  ResultData({
    required this.studentId,
    required this.examId,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      studentId: json['student_id'],
      examId: json['exam_id'],
    );
  }
}

class DoctorSuccessRate {
  final String name;
  final double successRate;

  DoctorSuccessRate({required this.name, required this.successRate});
}
