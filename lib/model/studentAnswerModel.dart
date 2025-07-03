class studentAnswerModel {
  final int questionId;
  final int selectedOption;

  studentAnswerModel({required this.questionId, required this.selectedOption});

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'selected_option': selectedOption,
      };
}
