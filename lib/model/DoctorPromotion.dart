class DoctorPromotion {
  final int doctorId;
  final String doctorName;
  final List<String> subjects;
  final double promotionRate;
  final String? message;

  DoctorPromotion({
    required this.doctorId,
    required this.doctorName,
    required this.subjects,
    required this.promotionRate,
    this.message,
  });

  factory DoctorPromotion.fromJson(Map<String, dynamic> json) {
    return DoctorPromotion(
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      subjects: List<String>.from(json['subjects']),
      promotionRate: (json['promotionRate'] as num).toDouble(),
      message: json['message'],
    );
  }
}
