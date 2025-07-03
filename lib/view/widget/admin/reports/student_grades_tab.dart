import 'package:eduction_system/controller/admin/ReportController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/core/them/app_colors.dart';

class StudentGradesTab extends StatelessWidget {
  const StudentGradesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PromotionController());

    // البيانات تجلب مرة وحدة عند تهيئة الكونترولر، مش لازم تجلبها كل مرة تبني الواجهة
    // إذا بدك، يمكن تستدعيها هنا لو حابب تتأكد:
    // controller.fetchStudentsSubjectsScores();

    return GetBuilder<PromotionController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.students.isEmpty) {
          return const Center(child: Text("لا توجد بيانات درجات للطلاب."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.students.length,
          itemBuilder: (context, index) {
            final student = controller.students[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.username,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'متوسط الدرجات: ${student.average.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    student.hasResults && student.subjects.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: student.subjects.map((subject) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        subject.subjectName,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Text(
                                      '${subject.score}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: subject.promotionStatus ==
                                                'promoted'
                                            ? AppColors.success
                                            : AppColors.error,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: subject.promotionStatus ==
                                                'promoted'
                                            ? AppColors.success.withOpacity(0.2)
                                            : AppColors.error.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        subject.promotionStatus == 'promoted'
                                            ? 'ناجح'
                                            : 'راسب',
                                        style: TextStyle(
                                          color: subject.promotionStatus ==
                                                  'promoted'
                                              ? AppColors.success
                                              : AppColors.error,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        : const Text(
                            'لا توجد درجات متاحة لهذا الطالب',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
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
