import 'package:eduction_system/controller/auth/signUp_controller.dart';
import 'package:eduction_system/core/classes/staterequest.dart';
import 'package:eduction_system/core/function/validinput.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:eduction_system/view/screen/auth/login.dart';
import 'package:eduction_system/view/screen/auth/loginStudent.dart';
import 'package:eduction_system/view/widget/auth/CustomButton.dart';
import 'package:eduction_system/view/widget/auth/CustomTextFormFiled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SignUpControllerImp());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GetBuilder<SignUpControllerImp>(
            builder: (controller) {
              return SingleChildScrollView(
                child: Form(
                  key: controller.formState,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: controller.phone,
                          validator: (val) =>
                              validInput(val!, 10, 100, "phone"),
                          label: " رقم الهاتف",
                          hintText: "أدخل رقم الهاتف",
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          isDarkMode: false,
                        ),
                        const SizedBox(height: 16),
                        if (controller.userType == "student") ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "المرحلة الدراسية",
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: controller.selectedStudentYear,
                                decoration: InputDecoration(
                                  hintText: 'اختر المرحلة الدراسية',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color:
                                          AppColors.lightGrey.withOpacity(0.5)!,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color:
                                          AppColors.lightGrey.withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary),
                                  ),
                                ),
                                items: controller.studentYears.map((year) {
                                  return DropdownMenuItem(
                                    value: year,
                                    child: Text(year),
                                  );
                                }).toList(),
                                onChanged: controller.setSelectedStudentYear,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'يرجى اختيار المرحلة الدراسية';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                             Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "القسم",
                                   
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<int>(
                                    value: controller.departments.any((d) =>
                                            d['department_id'] ==
                                            controller.selectedDepartmentId)
                                        ? controller.selectedDepartmentId
                                        : null,
                                    decoration: InputDecoration(
                                      hintText: 'اختر القسم',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppColors.lightGrey
                                              .withOpacity(0.5)!,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppColors.lightGrey
                                              .withOpacity(0.5),
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: AppColors.primary),
                                      ),
                                    ),
                                    items: controller.departments.map((dept) {
                                      return DropdownMenuItem<int>(
                                        value: dept['department_id'],
                                        child: Text(dept['name']),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      controller.setSelectedDepartment(value);
                                    },
                                    validator: (val) {
                                      if (val == null) {
                                        return 'يرجى اختيار القسم';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              )

                            ],
                          ),
                        ],
                        const SizedBox(height: 40),
                        CustomButton(
                          text: 'إنشاء حساب',
                          onPressed: () {
                            controller.signup();
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("لديك حساب بالفعل؟"),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () => Get.to(() => LoginStudents()),
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // مهم حتى ما ياخد كل عرض الشاشة
                                children: [
                                  Text(
                                    "تسجيل الدخول",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.login,
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
