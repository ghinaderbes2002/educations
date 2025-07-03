import 'package:eduction_system/model/userModel.dart';

class MessageModel {
  final int messageId;
  final int studentId;
  final int doctorId;
  final String messageText;
  final DateTime sentAt;
  final UserModel? student;
  final UserModel? doctor; // ✅ أضف هذا الحقل

  MessageModel({
    required this.messageId,
    required this.studentId,
    required this.doctorId,
    required this.messageText,
    required this.sentAt,
    this.student,
    this.doctor, // ✅
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['message_id'],
      studentId: json['student_id'],
      doctorId: json['doctor_id'],
      messageText: json['message_text'],
      sentAt: DateTime.parse(json['sent_at']),
      student:
          json['student'] != null ? UserModel.fromJson(json['student']) : null,
      doctor: json['doctor'] != null
          ? UserModel.fromJson(json['doctor'])
          : null, // ✅
    );
  }
}
