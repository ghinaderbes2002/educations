import 'package:eduction_system/controller/auth/login_controller.dart';
import 'package:eduction_system/core/constant/App_routes.dart';
import 'package:eduction_system/core/function/validinput.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:eduction_system/view/widget/auth/CustomButton.dart';
import 'package:eduction_system/view/widget/auth/CustomTextFormFiled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginStudents extends StatelessWidget {
  const LoginStudents({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginControllerImp());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GetBuilder<LoginControllerImp>(
            builder: (controller) {
              return SingleChildScrollView(
                child: Form(
                  key: controller.formState,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const SizedBox(height: 15),
                        const Text(
                          "eduction",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomTextFormField(
                          controller: controller.name,
                          label: 'الاسم الكامل',
                          hintText: 'أدخل الاسم الكامل',
                          prefixIcon: Icons.person_outline,
                          validator: (val) =>
                              validInput(val!, 3, 100, "username"),
                          isDarkMode: false,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: controller.password,
                          label: "كلمة المرور",
                          hintText: "********",
                          prefixIcon: Icons.lock_outline,
                          isPassword: controller.isPasswordHidden,
                          onPasswordToggle: controller.togglePasswordVisibility,
                          validator: controller.validatePassword,
                          isDarkMode: false,
                        ),
                       
                        const SizedBox(height: 40),
                        CustomButton(
                          text: 'تسجيل الدخول',
                          onPressed: () {
                            controller.login();
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(" ليس لديك حساب ؟"),
                            SizedBox(width: 5),
                            GestureDetector(
                              onTap: () => Get.offAllNamed(AppRoute.signup),
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // مهم حتى ما ياخد كل عرض الشاشة
                                children: [
                                  Text(
                                    " إنشاء حساب",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.person_add,
                                      size: 18, color: AppColors.primary),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
