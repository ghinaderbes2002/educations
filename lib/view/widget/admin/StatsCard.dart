import 'package:eduction_system/controller/auth/StatsController.dart';
import 'package:eduction_system/view/widget/admin/StatItemCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatsController>(
      init: StatsController(),
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.analytics_rounded,
                    color: Color(0xFF2E3A59),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'إحصائيات سريعة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatItemCard(
                      title: 'الدكاترة',
                      count: controller.doctorsCount.toString(),
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: StatItemCard(
                      title: 'الأقسام',
                      count: controller.departmentsCount.toString(),
                      icon: Icons.domain,
                      color: const Color(0xFF66BB6A),
                    ),
                  ),
                  Expanded(
                    child: StatItemCard(
                      title: 'المواد',
                      count: controller.subjectsCount.toString(),
                      icon: Icons.book,
                      color: const Color(0xFFAB47BC),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
