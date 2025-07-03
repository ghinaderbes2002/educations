import 'package:eduction_system/controller/students/StudentController.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentGradesScreen extends StatelessWidget {
  final int studentId;
  final int academicYear;

  const StudentGradesScreen({
    super.key,
    required this.studentId,
    required this.academicYear,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentControllerImp());

    // جلب المعدل والدرجات
    controller.fetchStudentAverage(studentId, academicYear);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<StudentControllerImp>(
        builder: (controller) {
          if (controller.isLoading) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "كشف العلامات",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                backgroundColor: AppColors.primary,
                elevation: 2,
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          final average = controller.average;

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "كشف العلامات",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              backgroundColor: AppColors.primary,
              elevation: 2,
            ),
            body: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 70,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "المعدل السنوي",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${average.toStringAsFixed(2)} / 20",
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
