import 'package:eduction_system/core/constant/App_routes.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:eduction_system/view/widget/onBoarding.dart/UserTypeCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
            AppColors.primary,
              AppColors.primary,            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).padding.top,
              ),
              child: Column(
                children: [
              // Header Section
              Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    // Logo Container
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Welcome Text
                    Text(
                      "أهلاً وسهلاً",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    Text(
                      "نظام التعليم المتطور",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    Text(
                      "اختر نوع حسابك للبدء",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Cards Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserTypeCard(
                        title: "طالب",
                        description: "ابدأ رحلتك التعليمية الآن وتعلم بطريقة تفاعلية",
                        icon: Icons.person_rounded,
                        color: Colors.blue,
                        onTap: () {
                          Get.toNamed(AppRoute.signup);
                        },
                      ),
                      
                      SizedBox(height: 20),
                      
                      UserTypeCard(
                        title: "مدير النظام",
                        description: "إدارة شاملة للنظام والمحتوى التعليمي",
                        icon: Icons.admin_panel_settings_rounded,
                        color: Colors.orange,
                        onTap: () {
                          // التنقل لصفحة الأدمن
                              Get.toNamed(AppRoute.login);
                        },
                      ),
                        SizedBox(height: 20),
                          UserTypeCard(
                            title: " دكتور",
                            description: "إدارة شاملة للنظام والمحتوى التعليمي",
                            icon: Icons.admin_panel_settings_rounded,
                            color: Colors.green,
                            onTap: () {
                              // التنقل لصفحة الأدمن
                              Get.toNamed(AppRoute.login);
                            },
                          ),
                                          
                    ],
                  ),
                ),
              ),
                ],
              ),
            ),
          ),
          
          
        ),
      ),
    );
  }
}