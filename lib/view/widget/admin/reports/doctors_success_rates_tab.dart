import 'package:eduction_system/controller/admin/ReportController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorsSuccessRatesTab extends StatefulWidget {
  const DoctorsSuccessRatesTab({super.key});

  @override
  State<DoctorsSuccessRatesTab> createState() => _DoctorsSuccessRatesTabState();
}

class _DoctorsSuccessRatesTabState extends State<DoctorsSuccessRatesTab> {
  final PromotionController controller = Get.put(PromotionController());

  @override
  void initState() {
    super.initState();
    // تم حذف استدعاء fetchPromotionRates() لأنه موجود في onInit()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: GetBuilder<PromotionController>(
        builder: (_) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.doctorsSuccessRates.isEmpty) {
            return Center(
              child: Text(
                "لا توجد بيانات نسب نجاح.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            itemCount: controller.doctorsSuccessRates.length,
            separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
            itemBuilder: (context, index) {
              final doctor = controller.doctorsSuccessRates[index];
              return ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    doctor.name.isNotEmpty ? doctor.name[0] : '?',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  doctor.name,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  'نسبة النجاح: ${doctor.successRate.toStringAsFixed(2)}%',
                  style: TextStyle(color: Colors.black87),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
