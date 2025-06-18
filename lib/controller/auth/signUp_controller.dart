import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/classes/staterequest.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


abstract class SignUpController extends GetxController {
  signup();
}

class SignUpControllerImp extends SignUpController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  late TextEditingController name;
  late TextEditingController phone;
  late TextEditingController password;

  Staterequest staterequest = Staterequest.none;

  bool isPasswordHidden = true;


  List<String> studentYears = [
    'السنة الأولى',
    'السنة الثانية',
    'السنة الثالثة',
    'السنة الرابعة',
    'السنة الخامسة',
  ];

  String? selectedStudentYear;

  void setSelectedStudentYear(String? year) {
    selectedStudentYear = year;
    update();
  }

String userType = "student"; // غيّرها حسب الحاجة




  @override
  signup() async {
    ApiClient apiClient = ApiClient();
    if (formState.currentState!.validate()) {
      staterequest = Staterequest.loading;
      update();
      try {
        ApiResponse<dynamic> postResponse = await apiClient
            .postData(url: '$serverLink/auth/user_register', data: {
          'name_user': name.text.trim(),
          'password': password.text.trim(),
          'phone_number': phone.text.trim(),
        });
        print('POST Response Data: ${postResponse.data}');
        if (postResponse.statusCode == 201 &&
            postResponse.data["state"] == "success") {
          // Get.offAll(() => const MainHome());
        } else {
          Get.snackbar("خطأ", postResponse.data["msg"] ?? "فشل التسجيل");
        }
      } catch (error) {
        print("Signup error: $error");
        Get.snackbar("خطأ", "حدث خطأ غير متوقع: $error");
      } finally {
        staterequest = Staterequest.none;
        update();
      }
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }

    // تحقق من طول كلمة المرور
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل';
    }

    // تحقق من وجود حرف كبير
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل';
    }

    // تحقق من وجود حرف صغير
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'كلمة المرور يجب أن تحتوي على حرف صغير واحد على الأقل';
    }

    // تحقق من وجود رقم
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
    }

    // تحقق من وجود رمز خاص
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'كلمة المرور يجب أن تحتوي على رمز خاص واحد على الأقل (@\$!%*?& وغيرها)';
    }

    return null;
  }

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  @override
  void onInit() {
    name = TextEditingController();
    phone = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }
}
