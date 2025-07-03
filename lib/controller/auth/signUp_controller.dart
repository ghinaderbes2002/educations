import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/classes/staterequest.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:eduction_system/view/screen/OnboardingScreen.dart';
import 'package:eduction_system/view/screen/auth/loginStudent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpControllerImp extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  late TextEditingController name;
  late TextEditingController phone;
  late TextEditingController password;

  Staterequest staterequest = Staterequest.none;

  List<Map<String, dynamic>> departments = [];
  int? selectedDepartmentId; // القسم المحدد ✅

  bool isPasswordHidden = true;

  String userType = "student"; // غيّرها حسب الحاجة

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

  void setSelectedDepartment(int? id) {
    selectedDepartmentId = id;
    update();
  }

  int convertYearToNumber(String? year) {
    switch (year) {
      case 'السنة الأولى':
        return 1;
      case 'السنة الثانية':
        return 2;
      case 'السنة الثالثة':
        return 3;
      case 'السنة الرابعة':
        return 4;
      case 'السنة الخامسة':
        return 5;
      default:
        return 1;
    }
  }

  signup() async {
    ApiClient apiClient = ApiClient();

    if (formState.currentState!.validate()) {
      if (selectedStudentYear == null) {
        Get.snackbar("تنبيه", "الرجاء اختيار السنة الدراسية");
        return;
      }

      if (selectedDepartmentId == null) {
        Get.snackbar("تنبيه", "الرجاء اختيار القسم");
        return;
      }

      staterequest = Staterequest.loading;
      update();

      try {
        ApiResponse<dynamic> postResponse = await apiClient.postData(
          url: '${ServerConfig().serverLink}/auth/register',
          data: {
            'username': name.text.trim(),
            'password': password.text.trim(),
            'academic_year': convertYearToNumber(selectedStudentYear),
            'phone': phone.text.trim(),
            'department_id': selectedDepartmentId, // ✅ القسم المحدد
          },
        );

        print('POST Response Data: ${postResponse.data}');

        if (postResponse.statusCode == 201) {
          Get.snackbar("تم", "تم إنشاء الحساب بنجاح");
          Get.offAll(() => LoginStudents());
        } else {
          Get.snackbar("خطأ", postResponse.data["message"] ?? "فشل التسجيل");
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

  Future<void> fetchDepartments() async {
    staterequest = Staterequest.loading;
    update();

    try {
      ApiClient apiClient = ApiClient();

      ApiResponse<dynamic> response = await apiClient.getData(
        url: '${ServerConfig().serverLink}/departments/with-subjects',
      );

      if (response.statusCode == 200 && response.data != null) {
        departments = List<Map<String, dynamic>>.from(response.data);
        print('Loaded departments: $departments');
      } else {
        Get.snackbar("خطأ", "فشل في تحميل الأقسام");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء تحميل الأقسام: $e");
    } finally {
      staterequest = Staterequest.none;
      update();
    }
  }

  Future<void> logout() async {
    ApiClient apiClient = ApiClient();
    final MyServices myServices = Get.find<MyServices>();

    final token = myServices.sharedPref.getString("token");
    if (token == null) {
      Get.snackbar("خطأ", "المستخدم غير مسجل الدخول");
      return;
    }

    try {
      ApiResponse<dynamic> response = await apiClient.postData(
        url: '${ServerConfig().serverLink}/auth/logout',
        data: {},
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await myServices.sharedPref.remove("token");
        await myServices.sharedPref.remove("user");
        await myServices.sharedPref.remove("role");
        await myServices.sharedPref.remove("userId");
        await myServices.sharedPref.remove("academicYear");
        await myServices.sharedPref.remove("isLoggedIn"); // ✅ هذا أهم سطر

        Get.snackbar("تم", "تم تسجيل الخروج بنجاح");

        // إعادة التوجيه لواجهة البداية
        Get.offAll(() => OnboardingScreen());
      } else {
        Get.snackbar("خطأ",
            "فشل تسجيل الخروج: ${response.data["message"] ?? "خطأ غير معروف"}");
      }
    } catch (e) {
      print("Logout error: $e");
      Get.snackbar("خطأ", "حدث خطأ أثناء تسجيل الخروج");
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'كلمة المرور يجب أن تحتوي على حرف صغير واحد على الأقل';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'كلمة المرور يجب أن تحتوي على رمز خاص واحد على الأقل';
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
    fetchDepartments(); // جلب الأقسام
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
