import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/controller/admin/ReportController.dart';
import 'package:eduction_system/core/them/app_colors.dart';

class DoctorsSuccessRatesTab extends StatelessWidget {
  const DoctorsSuccessRatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();

    return ListView.builder(
      itemCount: controller.doctorsSuccessRates.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final doctor = controller.doctorsSuccessRates[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'نسبة النجاح: ${doctor.successRate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: doctor.successRate / 100,
                    backgroundColor: AppColors.error.withOpacity(0.2),
                    color: AppColors.success,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
