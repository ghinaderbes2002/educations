class ExamModel {
  final int id;
  final String title;
  final DateTime date;
  final int duration; // بالدقائق
  final int subjectId;

  ExamModel({
    required this.id,
    required this.title,
    required this.date,
    required this.duration,
    required this.subjectId,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      duration: json['duration'],
      subjectId: json['subjectId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'duration': duration,
      'subjectId': subjectId,
    };
  }
}
