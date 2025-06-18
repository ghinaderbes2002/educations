import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:eduction_system/model/departmentModel.dart';
import 'package:eduction_system/model/subjectModel.dart';
import 'package:eduction_system/model/userModel.dart'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class SubjectController extends GetxController {
  fetchDepartments();
  fetchSubjects();
  fetchDoctors(); // لجلب الدكاترة
  deleteSubject(int subjectId);
  createSubject({
    required String name,
    required int academicYear,
    required int departmentId,
    required int doctorId,
  });
updateSubject(SubjectModel updatedSubject) ;
}

class SubjectControllerImp extends SubjectController {


  TextEditingController nameController = TextEditingController();

    bool isLoading = false;

    int? currentEditingSubjectId;



  List<DepartmentModel> departments =[];
  List<UserModel> doctors = [];
  List<SubjectModel> subjects = [];
  

  DepartmentModel? selectedDepartment;
  UserModel? selectedDoctor;



  @override
  Future<void> fetchDepartments() async {
    ApiClient apiClient = ApiClient();

    try {
      isLoading = true;
      update();

      ApiResponse response = await apiClient.getData(
        url: '$serverLink/departments',
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
  Future<void> fetchSubjects() async {
    ApiClient apiClient = ApiClient();

    try {
      ApiResponse response = await apiClient.getData(
        url: '$serverLink/subjects',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print("Raw subjects data: $data"); // للمراجعة

        subjects = data.map((json) => SubjectModel.fromJson(json)).toList();
        update();
        print("✔️ تم تحميل ${subjects.length} مادة");
      } else {
        Get.snackbar("خطأ", "فشل في تحميل المواد: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء جلب بيانات المواد");
      print("Exception during fetchSubjects: $e");
    }
  }


  @override
  Future<bool> createSubject({
    required String name,
    required int academicYear,
    required int departmentId,
    required int doctorId,
  }) async {
    ApiClient apiClient = ApiClient();

    final MyServices myServices = Get.find<MyServices>();
    final token = myServices.sharedPref.getString("token");

    if (token == null) {
      Get.snackbar("خطأ", "لم يتم العثور على توكن المستخدم.");
      return false;
    }

    Map<String, dynamic> subjectData = {
      'name': name.trim(),
      'academic_year': academicYear,
      'department_id': departmentId,
      'doctor_id': doctorId,
    };

    ApiResponse response = await apiClient.postData(
      url: '$serverLink/subjects',
      data: subjectData,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar("نجاح", "تمت إضافة المادة بنجاح");

      subjects.add(SubjectModel.fromJson(response.data));
      update();

      return true;
    } else {
      print("خطأ في إضافة المادة: ${response.statusCode} - ${response.data}");
      Get.snackbar("خطأ", "فشل إضافة المادة: ${response.data}");
      return false;
    }
  }


@override
 Future<void> fetchDoctors() async {
    ApiClient apiClient = ApiClient();

    try {
      ApiResponse response = await apiClient.getData(
        url: '$serverLink/users/doctors',
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
  Future<bool> updateSubject(SubjectModel updatedSubject) async {

    print("\n\n\n\n\n\n  test \n\n\n\n\n\n : ");
    ApiClient apiClient = ApiClient();
    final MyServices myServices = Get.find<MyServices>();
    final token = myServices.sharedPref.getString("token");

    if (token == null) {
      Get.snackbar("خطأ", "لم يتم العثور على توكن المستخدم.");
      return false;
    }

    Map<String, dynamic> subjectData = {
      'name': updatedSubject.name.trim(),
      'academic_year': updatedSubject.academicYear,
      'department_id': updatedSubject.departmentId,
      'doctor_id': updatedSubject.doctorId,
    };

    ApiResponse response = await apiClient.patchData(
      url: '$serverLink/subjects/${updatedSubject.subjectId}',
      data: subjectData,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      Get.snackbar("نجاح", "تم تعديل بيانات المادة بنجاح");

      int index = subjects
          .indexWhere((subj) => subj.subjectId == updatedSubject.subjectId);
      if (index != -1) {
        subjects[index] = updatedSubject;
        update();
      }
      return true;
    } else {
      Get.snackbar("خطأ", "فشل تعديل المادة: ${response.data}");
      return false;
    }
  }

 @override
  Future<void> deleteSubject(int subjectId) async {
    ApiClient apiClient = ApiClient();

    try {
      ApiResponse response = await apiClient.deleteData(
        url: '$serverLink/subjects/$subjectId',
        // headers إذا لازم، لو موجودة تلقائياً في deleteData ما تحتاج
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("✔️ تم حذف المادة رقم $subjectId بنجاح");
        await fetchSubjects(); // إعادة تحميل المواد بعد الحذف
        update();
      } else {
        Get.snackbar("خطأ", "فشل في حذف المادة: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء حذف المادة");
      print("Exception during deleteSubject: $e");
    }
  }


  void setSelectedDepartment(DepartmentModel? dep) {
    selectedDepartment = dep;
    update();
  }

  void setSelectedDoctor(UserModel? doc) {
    selectedDoctor = doc;
    update();
  }

  @override
  void onInit() {
    fetchDepartments(); 
    fetchDoctors();
    fetchSubjects();
    super.onInit();
  }
}
