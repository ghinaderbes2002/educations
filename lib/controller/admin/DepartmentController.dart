import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/classes/staterequest.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:eduction_system/model/departmentModel.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

abstract class DepartmentController extends GetxController {
  createDepartment({required String name});
  updateDepartment(int departmentId, String newName);
  fetchDepartments();
  deleteDepartment(int id);
}

class DepartmentControllerImp extends DepartmentController {
  List<DepartmentModel> departments = [];

  final TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Staterequest staterequest = Staterequest.none;
  bool isLoading = false;

  @override
  Future<bool> createDepartment({required String name}) async {
    ApiClient apiClient = ApiClient();
    final MyServices myServices = Get.find<MyServices>();
    final token = myServices.sharedPref.getString("token");

    if (token == null) {
      Get.snackbar("خطأ", "لم يتم العثور على توكن المستخدم.");
      return false;
    }

    Map<String, dynamic> departmentData = {
      'name': name.trim(),
    };

    ApiResponse response = await apiClient.postData(
      url: '${ServerConfig().serverLink}/departments',
      data: departmentData,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar("نجاح", "تم إضافة القسم بنجاح");

      // ✅ أضف القسم الجديد للقائمة مباشرة
      final newDep = DepartmentModel.fromJson(response.data);
      departments.add(newDep);
      update(); // تحدث الواجهة
      return true;
    } else {
      Get.snackbar("خطأ", "فشل إضافة القسم: ${response.data}");
      return false;
    }
  }

  @override
  Future<bool> updateDepartment(int departmentId, String newName) async {
    ApiClient apiClient = ApiClient();

    final MyServices myServices = Get.find<MyServices>();
    final token = myServices.sharedPref.getString("token");
    print("Token from storage: $token");

    if (token == null) {
      Get.snackbar("خطأ", "لم يتم العثور على توكن المستخدم.");
      return false;
    }

    Map<String, dynamic> departmentData = {
      'name': newName.trim(),
    };

    ApiResponse response = await apiClient.patchData(
      url: '${ServerConfig().serverLink}/departments/$departmentId',
      data: departmentData,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      Get.snackbar("نجاح", "تم تعديل القسم بنجاح");
      // إذا عندك لائحة أقسام مخزنة محليًا، حدّثها هون
      return true;
    } else {
      Get.snackbar("خطأ", "فشل تعديل القسم: ${response.data}");
      return false;
    }
  }

  @override
  Future<void> deleteDepartment(int id) async {
    ApiClient apiClient = ApiClient();

    try {
      ApiResponse response = await apiClient.deleteData(
        url: '${ServerConfig().serverLink}/departments/$id',
        // ما بتمرير headers هنا، لأنه موجودة تلقائيًا داخل deleteData
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("✔️ تم حذف القسم رقم $id بنجاح");
        await fetchDepartments(); // إعادة تحميل الأقسام
        update();
      } else {
        Get.snackbar("خطأ", "فشل في حذف القسم: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء حذف القسم");
      print("Exception during deleteDepartment: $e");
    }
  }

  @override
  Future<void> fetchDepartments() async {
    ApiClient apiClient = ApiClient();

    try {
      isLoading = true;
      update();

      ApiResponse response = await apiClient.getData(
        url: '${ServerConfig().serverLink}/departments',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print("Raw departments data: $data"); // للتأكد

        departments =
            data.map((json) => DepartmentModel.fromJson(json)).toList();
        print("✔️ تم تحميل ${departments.length} قسم");
      } else {
        Get.snackbar("خطأ", "فشل في تحميل الأقسام: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء جلب بيانات الأقسام");
      print("Exception during fetchDepartments: $e");
    } finally {
      isLoading = false; // لازم نوقف الدوّارة بعد الانتهاء مهما صار
      update();
    }
  }

  @override
  void onInit() {
    fetchDepartments();
    super.onInit();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
