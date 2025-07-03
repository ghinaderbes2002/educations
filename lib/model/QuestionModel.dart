class QuestionModel {
  final int questionId;
  final String questionText;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final int correctOption;

  QuestionModel({
    required this.questionId,
    required this.questionText,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.correctOption,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionId: json['question_id'],
      questionText: json['question_text'],
      option1: json['option1'],
      option2: json['option2'],
      option3: json['option3'],
      option4: json['option4'],
      correctOption: json['correct_option'],
    );
  }
}