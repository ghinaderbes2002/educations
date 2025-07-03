import 'package:eduction_system/controller/students/StudentController.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StudentInboxScreen extends StatelessWidget {
  const StudentInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentControllerImp());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchInboxMessages();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "رسائل الدكتور",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 4,
      ),
      body: GetBuilder<StudentControllerImp>(
        builder: (_) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.inboxMessages.isEmpty) {
            return const Center(
              child: Text(
                "لا توجد رسائل",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.inboxMessages.length,
            itemBuilder: (context, index) {
              final msg = controller.inboxMessages[index];
              final doctorName = msg.doctor?.username ?? 'غير معروف';
              final time = DateFormat('yyyy/MM/dd – HH:mm').format(msg.sentAt);

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  title: SelectableText(
                    msg.messageText,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      "من: $doctorName\n📅 $time",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
