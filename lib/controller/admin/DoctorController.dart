import 'package:eduction_system/controller/auth/StatsController.dart';
import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:eduction_system/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class DoctorController extends GetxController {
  createDoctor({
    required String username,
    required String password,
    required String phone,
  });
  updateDoctor(UserModel updatedDoctor);
  deleteDoctor(int id);
  fetchDoctors();
}

class DoctorControllerImp extends DoctorController {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  final statsController = Get.put(StatsController());

  List<UserModel> doctors = [];
  bool isLoading = false;

  @override
  Future<bool> createDoctor({
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

    Map<String, dynamic> doctorData = {
      'username': username.trim(),
      'password': "$phone@Doctor@123",
      'phone': phone.trim(),
    };

    ApiResponse response = await apiClient.postData(
      url: '${ServerConfig().serverLink}/auth/create-doctor',
      data: doctorData,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar("نجاح", "تم إضافة الدكتور بنجاح");

      doctors.add(UserModel(
        user_id: doctors.length + 1,
        username: username,
        phone: phone,
        password: password,
        role: "doctor",
      ));
      update();
      statsController.fetchAllStats(); // حتى تتحدث الواجهة المرتبطة فيه

      return true;
    } else {
      Get.snackbar("خطأ", "فشل إضافة الدكتور: ${response.data}");
      return false;
    }
  }

  @override
  Future<bool> updateDoctor(UserModel updatedDoctor) async {
    ApiClient apiClient = ApiClient();

    final MyServices myServices = Get.find<MyServices>();
    final token = myServices.sharedPref.getString("token");
    print("Token from storage: $token");

    if (token == null) {
      Get.snackbar("خطأ", "لم يتم العثور على توكن المستخدم.");
      return false;
    }

    Map<String, dynamic> doctorData = {
      'username': updatedDoctor.username?.trim(),
      'phone': updatedDoctor.phone?.trim(),
      'role': updatedDoctor.role,
    };

    // أرسل كلمة المرور فقط إذا غيرت كلمة المرور (ليست فارغة)
    if (updatedDoctor.password!.trim().isNotEmpty) {
      doctorData['password'] = updatedDoctor.password!.trim();
    }

    ApiResponse response = await apiClient.patchData(
      url:
          '${ServerConfig().serverLink}/users/doctors/${updatedDoctor.user_id}',
      data: doctorData,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      Get.snackbar("نجاح", "تم تعديل بيانات الدكتور بنجاح");

      int index =
          doctors.indexWhere((doc) => doc.user_id == updatedDoctor.user_id);
      if (index != -1) {
        doctors[index] = updatedDoctor;
        update();
      }
      return true;
    } else {
      Get.snackbar("خطأ", "فشل تعديل الدكتور: ${response.data}");
      return false;
    }
  }

  @override
  Future<void> fetchDoctors() async {
    ApiClient apiClient = ApiClient();

    try {
      ApiResponse response = await apiClient.getData(
        url: '${ServerConfig().serverLink}/users/doctors',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print("Raw doctors data: $data"); // للتأكد

        doctors = data.map((json) => UserModel.fromJson(json)).toList();
        update();
        print("✔️ تم تحميل ${doctors.length} دكتور(ة)");
      } else {
        Get.snackbar("خطأ", "فشل في تحميل الدكاترة: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء جلب بيانات الدكاترة");
      print("Exception during fetchDoctors: $e");
    }
  }

  @override
  Future<void> deleteDoctor(int id) async {
    ApiClient apiClient = ApiClient();

    try {
      ApiResponse response = await apiClient.deleteData(
        url: '${ServerConfig().serverLink}/users/doctors/$id',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("✔️ تم حذف الدكتور رقم $id بنجاح");
        // ممكن تحدث القائمة أو تعمل أي شيء بعد الحذف
        await fetchDoctors(); // لو بدك تعيد تحميل الدكاترة
        update();
        statsController.fetchAllStats(); // حتى تتحدث الواجهة المرتبطة فيه
      } else {
        Get.snackbar("خطأ", "فشل في حذف الدكتور: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء حذف الدكتور");
      print("Exception during deleteDoctor: $e");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }
}
