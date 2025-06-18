import 'package:eduction_system/view/widget/admin/reports/doctors_success_rates_tab.dart';
import 'package:eduction_system/view/widget/admin/reports/student_grades_tab.dart';
import 'package:eduction_system/view/widget/admin/reports/top_students_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/controller/admin/ReportController.dart';
import 'package:eduction_system/core/them/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  final ReportController controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: AppBar(
                title: const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'تقارير الأداء',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: AppColor.surface,
                    ),
                  ),
                ),
                centerTitle: true,
                backgroundColor: AppColors.primary,
                elevation: 0,
                bottom: const TabBar(
                  labelColor: AppColor.surface,
                  unselectedLabelColor: Colors.white,
                  indicatorColor: AppColor.surface,
                  tabs: [
                    Tab(text: 'كشف العلامات'),
                    Tab(text: 'ترتيب الأوائل'),
                    Tab(text: 'نسب النجاح'),
                  ],
                ),
              ),
            ),
          ),
          body: GetBuilder<ReportController>(
            builder: (controller) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return const TabBarView(
                children: [
                  StudentGradesTab(),
                  TopStudentsTab(),
                  DoctorsSuccessRatesTab(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
