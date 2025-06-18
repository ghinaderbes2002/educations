import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:eduction_system/model/ExamModel.dart';
import 'package:eduction_system/model/subjectModel.dart';
import 'package:get/get.dart';

abstract class DoctorController extends GetxController {
fetchSubjectsbydoctor();
fetchExamsBySubjectId(int subjectId);

}
 class DoctorControllerImp extends DoctorController {

  List<SubjectModel> subjects = [];
  List<ExamModel> exams = [];



  bool isLoading = false;

  @override
  void onInit() {
    fetchSubjectsbydoctor();
    super.onInit();
  }


@override
Future<void> fetchSubjectsbydoctor() async {
  ApiClient apiClient = ApiClient();
  isLoading = true;
  update(); 

  try {
    ApiResponse response = await apiClient.getData(
      url: '$serverLink/subjects',
    );

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      print("Raw subjects data: $data"); // Debug

      subjects = data.map((json) => SubjectModel.fromJson(json)).toList();
      print("✔️ تم تحميل ${subjects.length} مادة");
    } else {
      Get.snackbar("خطأ", "فشل في تحميل المواد: ${response.statusCode}");
    }
  } catch (e) {
    Get.snackbar("خطأ", "حدث خطأ أثناء جلب بيانات المواد");
    print("Exception during fetchSubjects: $e");
  } finally {
    isLoading = false;
    update(); // لازم تحدث الشاشة بعد التغيير
  }
}

@override
Future<void> fetchExamsBySubjectId(int subjectId) async {
    ApiClient apiClient = ApiClient();
    isLoading = true;
    update(); // لتحديث الواجهة

    try {
      ApiResponse response = await apiClient.getData(
        url: '$serverLink/subjects/$subjectId/exams',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print("Raw exams data: $data");

        exams = data.map((json) => ExamModel.fromJson(json)).toList();
        print("✔️ تم تحميل ${exams.length} امتحان");
      } else {
        Get.snackbar("خطأ", "فشل في تحميل الامتحانات: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء جلب الامتحانات");
      print("Exception during fetchExams: $e");
    } finally {
      isLoading = false;
      update(); // تحديث الواجهة بعد الانتهاء
    }
  }

}