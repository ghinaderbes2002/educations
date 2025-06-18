import 'package:eduction_system/controller/admin/AdminController.dart';
import 'package:eduction_system/core/them/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubAdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AdminController controller = Get.put(AdminController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة أدمن فرعي',
         style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 4,
        centerTitle: true,),
    
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formState,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: controller.usernameController,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      labelText: "اسم الموظف",
                      hintText: "أدخل اسم الموظف",
                      prefixIcon:
                          const Icon(Icons.person, color: AppColors.primary),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                    TextFormField(
                    controller: controller.passwordController,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      labelText: "كلمة المرور",
                      hintText: "ادخل كلمة المرور ",
                      prefixIcon:
                          const Icon(Icons.password, color: AppColors.primary),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  ),
                 const SizedBox(height: 12),
                  TextFormField(
                    controller: controller.phoneController,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      labelText: "رقم الهاتف ",
                      hintText: "ادخل رقم الهاتف ",
                      prefixIcon:
                          const Icon(Icons.phone, color: AppColors.primary),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  ),
                 
                  const SizedBox(height: 24),
                   Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: controller.createSubAdmin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                        ),
                        child: const Text("إنشاء أدمن"),
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
