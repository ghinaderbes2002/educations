

import 'package:eduction_system/controller/doctor/doctorController.dart';
import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DoctorInboxScreen extends StatelessWidget {
  const DoctorInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorsControllerImp());

    // تحميل الرسائل بعد انتهاء بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchInboxMessages();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "الرسائل الواردة",
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
      body: GetBuilder<DoctorsControllerImp>(
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
              final studentName = msg.student?.username ?? 'غير معروف';
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
                      "من: $studentName\n📅 $time",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.reply, color: AppColors.primary),
                  onTap: () {
                    _showReplyDialog(
                        context, controller, msg.studentId, studentName);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showReplyDialog(
    BuildContext context,
    DoctorsControllerImp controller,
    int studentId,
    String studentName,
  ) {
    final replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("الرد على $studentName"),
        content: TextField(
          controller: replyController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "اكتب الرد هنا...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () async {
              final reply = replyController.text.trim();

              if (reply.isEmpty) {
                Get.snackbar("خطأ", "الرد لا يمكن أن يكون فارغاً");
                return;
              }

              final myServices = Get.find<MyServices>();
              final doctorId = myServices.sharedPref.getInt('userId');

              if (doctorId == null) {
                Get.snackbar("خطأ", "لم يتم العثور على معرف الدكتور");
                return;
              }

              await controller.sendMessageToDoctorDirect(
                studentId: studentId,
                doctorId: doctorId,
                messageText: reply,
              );

              Navigator.pop(context);
              Get.snackbar("تم الإرسال", "تم إرسال الرد بنجاح");
            },
            child: const Text("إرسال"),
          ),
        ],
      ),
    );
  }
}
