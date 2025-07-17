import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/constant/App_link.dart';

class AdminController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future<void> createSubAdmin() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim();

    if (username.isEmpty || phone.isEmpty) {
      Get.snackbar("خطأ", "الرجاء تعبئة كل الحقول");
      return;
    }

    bool success = await createAdmin(
      username: username,
      password: password,
      phone: phone,
    );

    if (success) {
      Get.snackbar("نجاح", "تم إنشاء الأدمن بنجاح");
      usernameController.clear();
      passwordController.clear();
      phoneController.clear();
    }
  }

  Future<bool> createAdmin({
    required String username,
    required String password,
    required String phone,
  }) async {
    ApiClient apiClient = ApiClient();

    final MyServices myServices = Get.find<MyServices>();
    final token = myServices.sharedPref.getString("token");

    if (token == null) {
      Get.snackbar("خطأ", "لم يتم العثور على توكن المستخدم.");
      return false;
    }

    Map<String, dynamic> adminData = {
      'username': username,
      'password': "$phone@subAdmin@123",
      'phone': phone,
    };

    ApiResponse response = await apiClient.postData(
      url: '${ServerConfig().serverLink}/auth/create-admin',
      data: adminData,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      Get.snackbar("خطأ", "فشل إنشاء الأدمن: ${response.data}");
      return false;
    }
  }
}
