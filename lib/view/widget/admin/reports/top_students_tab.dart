import 'package:eduction_system/controller/admin/ReportController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/core/them/app_colors.dart';

class TopStudentsTab extends StatelessWidget {
  const TopStudentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PromotionController());

    return GetBuilder<PromotionController>(
      builder: (controller) {
        if (controller.isLoadingRankings) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.departmentRankings.isEmpty) {
          return const Center(child: Text("لا يوجد ترتيب للطلاب."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.departmentRankings.length,
          itemBuilder: (context, index) {
            final department = controller.departmentRankings[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      department.departmentName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...department.students.map((student) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                student.username,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Text(
                              'معدل: ${student.average.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: student.average > 0
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: student.average > 0
                                    ? AppColors.success.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                student.average > 0 ? 'مشارك' : 'بدون نتائج',
                                style: TextStyle(
                                  color: student.average > 0
                                      ? AppColors.success
                                      : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
