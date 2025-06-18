import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/controller/admin/ReportController.dart';
import 'package:eduction_system/core/them/app_colors.dart';

class StudentGradesTab extends StatelessWidget {
  const StudentGradesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();

    return ListView.builder(
      itemCount: controller.studentGrades.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final student = controller.studentGrades[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ListTile(
            title: Text(
              student.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              'العلامات: ${student.grades.join(', ')}',
              style: const TextStyle(fontSize: 14),
            ),
            trailing: const Icon(Icons.school, color: AppColors.primary),
          ),
        );
      },
    );
  }
}
