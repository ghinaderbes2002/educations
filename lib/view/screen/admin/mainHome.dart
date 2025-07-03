import 'package:eduction_system/controller/auth/signUp_controller.dart';
import 'package:eduction_system/core/constant/App_routes.dart';
import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:eduction_system/view/widget/admin/EnhancedCard.dart';
import 'package:eduction_system/view/widget/admin/StatsCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final myServices = Get.find<MyServices>();
    final role = myServices.sharedPref.getString("role");
    print("🚨 الدور الحالي: $role");

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'لوحة التحكم',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E3A59),
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E3A59),
                Color(0xFF3E4A69),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: 'تسجيل الخروج',
          onPressed: () async {
            bool? confirm = await Get.defaultDialog<bool>(
              title: 'تأكيد',
              middleText: 'هل أنت متأكد من تسجيل الخروج؟',
              textConfirm: 'نعم',
              textCancel: 'لا',
              onConfirm: () => Get.back(result: true),
              onCancel: () => Get.back(result: false),
            );

            if (confirm == true) {
              await Get.put(SignUpControllerImp()).logout();

              // ممكن ترجع لصفحة تسجيل الدخول، مثلا:
              Get.offAllNamed(AppRoute.onBoarding);
            }
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFE9ECEF),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    StatsCard(),
                    const SizedBox(height: 20),
                    if (role == "admin")
                    EnhancedCard(
                      title: 'إدارة الدكاترة',
                      subtitle: 'إضافة وتعديل وحذف الدكاترة',
                      icon: Icons.medical_services_rounded,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF345B83),
                          Color(0xFF345B83)
                        ], // أزرق هادئ
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => Get.toNamed(AppRoute.doctor),
                    ),
                    // بطاقة إدارة الأقسام
                    if (role == "admin")
                    EnhancedCard(
                      title: 'إدارة الأقسام',
                      subtitle: 'إدارة أقسام الكلية والتخصصات',
                      icon: Icons.domain_rounded,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF8BC4A5),
                          Color(0xFF8BC4A5)
                        ], // أخضر ناعم
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => Get.toNamed(AppRoute.department),
                    ),
                    // بطاقة إدارة المواد
                    if (role == "admin")
                    EnhancedCard(
                      title: 'إدارة المواد',
                      subtitle: 'إضافة وتنظيم المواد الدراسية',
                      icon: Icons.menu_book_rounded,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFBA68C8),
                          Color(0xFFBA68C8)
                        ], // بنفسجي ناعم
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => Get.toNamed(AppRoute.subject),
                    ),
                    if (role == "superadmin") 
                      EnhancedCard(
                        title: 'إدارة موظفين الشؤون',
                        subtitle: 'إضافة وتعديل وحذف الموظفين',
                        icon: Icons.manage_accounts,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF67C8FF), Color(0xFF67C8FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () => Get.toNamed(AppRoute.subAdmin),
                      ),

                    EnhancedCard(
                      title: 'إدارة التقارير',
                      subtitle: 'عرض وتحليل تقارير الأداء',
                      icon: Icons.analytics_rounded,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE890A3),
                          Color(0xFFE890A3)
                        ], // وردي هادئ
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => Get.toNamed(AppRoute.reports),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
