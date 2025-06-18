
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/controller/admin/ReportController.dart';
import 'package:eduction_system/core/them/app_colors.dart';

class TopStudentsTab extends StatelessWidget {
  const TopStudentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();

    return ListView.builder(
      itemCount: controller.topStudents.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, groupIndex) {
        final group = controller.topStudents[groupIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان القسم والسنة
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'القسم: ${group.departmentName} - السنة: ${group.academicYear}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            ),

            // قائمة أفضل 3 طلاب
            ...group.topStudents.asMap().entries.map((entry) {
              final index = entry.key;
              final student = entry.value;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'المعدل: ${student.average.toStringAsFixed(2)}',
                  ),
                  trailing: const Icon(Icons.star, color: Colors.amber),
                ),
              );
            }),
            const Divider(thickness: 1.2),
          ],
        );
      },
    );
  }
}
