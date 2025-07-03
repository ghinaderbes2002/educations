import 'package:eduction_system/controller/admin/DoctorController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDoctorForm extends StatefulWidget {
  @override
  State<AddDoctorForm> createState() => _AddDoctorFormState();
}

class _AddDoctorFormState extends State<AddDoctorForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final DoctorControllerImp controller = Get.put(DoctorControllerImp());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الاسم
            TextFormField(
              controller: nameController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                labelText: 'الاسم',
                labelStyle:
                    const TextStyle(fontFamily: 'Cairo', color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF2E3A59), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                prefixIcon: const Icon(Icons.person, color: Color(0xFF2E3A59)),
              ),
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
              validator: (val) =>
                  val == null || val.isEmpty ? 'أدخل الاسم' : null,
            ),
            const SizedBox(height: 12),

            // رقم الهاتف
            TextFormField(
              controller: phoneController,
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'رقم الهاتف',
                labelStyle:
                    const TextStyle(fontFamily: 'Cairo', color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF2E3A59), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF2E3A59)),
              ),
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
              validator: (val) =>
                  val == null || val.isEmpty ? 'أدخل رقم الهاتف' : null,
            ),
            const SizedBox(height: 12),

            // كلمة المرور
            TextFormField(
              controller: passwordController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                labelStyle:
                    const TextStyle(fontFamily: 'Cairo', color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF2E3A59), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                prefixIcon: const Icon(Icons.lock, color: Color(0xFF2E3A59)),
              ),
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
              obscureText: true,
              validator: (val) =>
                  val == null || val.isEmpty ? 'أدخل كلمة المرور' : null,
            ),
            const SizedBox(height: 20),

            // زر الإضافة
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final success = await controller.createDoctor(
                    username: nameController.text,
                    password: passwordController.text,
                    phone: phoneController.text,
                  );

                  if (success) {
                    Get.snackbar(
                      'نجاح',
                      'تمت إضافة الدكتور بنجاح',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.withOpacity(0.8),
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(12),
                      duration: const Duration(seconds: 3),
                    );
                    Get.back();
                  } else {
                    Get.snackbar(
                      'خطأ',
                      'فشل في إضافة الدكتور',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.withOpacity(0.8),
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(12),
                      duration: const Duration(seconds: 3),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E3A59),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                shadowColor: const Color(0xFF2E3A59).withOpacity(0.5),
              ),
              child: const Text(
                'إضافة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
