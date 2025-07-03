import 'dart:convert';

import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/classes/staterequest.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:eduction_system/core/constant/App_routes.dart';
import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:eduction_system/model/userModel.dart';
import 'package:eduction_system/view/screen/doctor/DoctorSubjects.dart';
import 'package:eduction_system/view/screen/admin/mainHome.dart';
import 'package:eduction_system/view/screen/sutdents/StudentSubjectsScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginController extends GetxController {
  login();
}

class LoginControllerImp extends LoginController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  late TextEditingController name;
  late TextEditingController password;


            final myServices = Get.find<MyServices>();


  Staterequest staterequest = Staterequest.none;

  bool isPasswordHidden = true;

  @override
  login() async {
    ApiClient apiClient = ApiClient();

    if (formState.currentState!.validate()) {
      staterequest = Staterequest.loading;
      update();

      try {
        ApiResponse<dynamic> postResponse = await apiClient.postData(
          url: '${ServerConfig().serverLink}/auth/login',
          data: {
            'username': name.text.trim(),
            'password': password.text.trim(),
          },
        );

        print('POST Response Data: ${postResponse.data}');
        print("Status Code: ${postResponse.statusCode}");

        if (postResponse.statusCode == 200 || postResponse.statusCode == 201) {
          // تأكد إن البيانات جت مع الرد
          final responseData = postResponse.data;

          // استخرج التوكن واليوزر من الداتا
          final token = responseData["accessToken"];
          final userData = responseData["user"];
          if (token != null && userData != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token);
            await prefs.setString('user', jsonEncode(userData));

            final academicYear = userData["academicYear"] ?? 1;
            await prefs.setInt('academicYear', academicYear);

            final userId = userData["user_id"] ?? userData["id"];
            await prefs.setInt('userId', userId); // <-- هنا الحفظ

            UserModel currentUser = UserModel.fromJson(userData);

            await myServices.sharedPref
                .setString("user", jsonEncode(currentUser.toJson()));
            await myServices.sharedPref.setString("token", token);
            await myServices.sharedPref.setInt('academicYear', academicYear);

            await myServices.sharedPref.setString("role", userData["role"]);
            await myServices.sharedPref.setBool("isLoggedIn", true);

            print("تم حفظ الدور: ${userData["role"]}");
            print("تم الحفظ: ${myServices.sharedPref.getString("token")}");
            print("تم حفظ بيانات المستخدم: ${currentUser.username}");
            print("تم حفظ التوكن: $token");
            print("تم حفظ السنة الدراسية: $academicYear");
          } else {
            Get.snackbar("خطأ", "بيانات المستخدم أو التوكن غير موجودة في الرد");
          }

          print("نجاح تسجيل الدخول");

          final role = userData["role"];

          if (role == "admin" || role == "superadmin") {
           await myServices.sharedPref.setInt("step", 1);

            Get.offAll(() => const AdminHomeScreen());

          } else if (role == "doctor") {
                       await myServices.sharedPref.setInt("step", 2);

            Get.offAll(() => DoctorSubjectsScreen());
          } else if (role == "student") {
                       await myServices.sharedPref.setInt("step", 3);

            Get.offAll(() => StudentSubjectsScreen());
          } else {
                                   await myServices.sharedPref.setInt("step", 4);

            Get.snackbar("خطأ", "دور غير معروف: $role");
          }
        } else {
          Get.snackbar(
              "خطأ", "فشل تسجيل الدخول: رمز الحالة ${postResponse.statusCode}");
        }
      } catch (error) {
        Get.snackbar("خطأ", "حدث خطأ غير متوقع: $error");
      } finally {
        staterequest = Staterequest.none;
        update();
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    update();
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

  @override
  void onInit() {
    name = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    name.dispose();
    password.dispose();
    super.dispose();
  }
}
