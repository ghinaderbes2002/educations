import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:eduction_system/model/DoctorPromotion.dart';
import 'package:get/get.dart';

class PromotionController extends GetxController {
  List<DoctorPromotion> doctorPromotions = [];

  double overallPromotionRate = 0;
  bool isLoading = false;

  // قائمة مبسطة فقط للاسم والنسبة للواجهة
  List<DoctorSuccessRate> doctorsSuccessRates = [];

  List<DepartmentRanking> departmentRankings = [];
  bool isLoadingRankings = false;

  Future<void> fetchRankings() async {
    isLoadingRankings = true;
    update(); // لعرض الـ CircularProgressIndicator مثلاً

    try {
      ApiClient apiClient = ApiClient();
      final response = await apiClient.getData(
        url: '${ServerConfig().serverLink}/exams/rankings',
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final List<dynamic> rankingsJson = data['rankings'];
        departmentRankings = rankingsJson
            .map((json) => DepartmentRanking.fromJson(json))
            .toList();
      } else {
        Get.snackbar('خطأ', 'فشل تحميل ترتيب الأوائل');
      }
    } catch (e) {
      print('Error fetching rankings: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء تحميل الترتيب');
    } finally {
      isLoadingRankings = false;
      update(); // لتحديث الواجهة بعد تحميل البيانات
    }
  }

  Future<void> fetchPromotionRates() async {
    isLoading = true;
    update(); // حدث الحالة عشان يظهر CircularProgressIndicator

    try {
      ApiClient apiClient = ApiClient();
      final response = await apiClient.getData(
        url: '${ServerConfig().serverLink}/exams/promotion-rate/doctor',
      );

      if (response.statusCode == 200) {
        final data = response.data;

        overallPromotionRate = (data['overallPromotionRate'] as num).toDouble();

        final List<dynamic> doctorsJson = data['doctorPromotions'];
        doctorPromotions =
            doctorsJson.map((json) => DoctorPromotion.fromJson(json)).toList();

        doctorsSuccessRates = doctorPromotions
            .map((dp) => DoctorSuccessRate(
                  name: dp.doctorName,
                  successRate: dp.promotionRate,
                ))
            .toList();
      } else {
        Get.snackbar('خطأ', 'فشل تحميل بيانات نسب النجاح');
      }
    } catch (e) {
      print('Error fetching promotion rates: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء جلب البيانات');
    } finally {
      isLoading = false;
      update(); // مهم يحدث الواجهة هنا برضه بعد الانتهاء
    }
  }

  List<StudentData> students = [];

  Future<void> fetchStudentsSubjectsScores() async {
    isLoading = true;
    update();

    try {
      ApiClient apiClient = ApiClient();
      final response = await apiClient.getData(
        url: '${ServerConfig().serverLink}/exams/students-subjects-scores',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> studentsJson = data['students'];

        students =
            studentsJson.map((json) => StudentData.fromJson(json)).toList();
      } else {
        Get.snackbar('خطأ', 'فشل تحميل بيانات الطلاب والدرجات');
      }
    } catch (e) {
      print('Error fetching students subjects scores: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء جلب البيانات');
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchPromotionRates();
    fetchStudentsSubjectsScores();
    fetchRankings();
  }
}

class DoctorSuccessRate {
  final String name;
  final double successRate;

  DoctorSuccessRate({required this.name, required this.successRate});
}

class StudentData {
  final int studentId;
  final String username;
  final List<SubjectScore> subjects;
  final bool hasResults;
  final double average;

  StudentData({
    required this.studentId,
    required this.username,
    required this.subjects,
    required this.hasResults,
    required this.average,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    var subjectsJson = json['subjects'] as List<dynamic>;
    List<SubjectScore> subjectsList =
        subjectsJson.map((e) => SubjectScore.fromJson(e)).toList();

    return StudentData(
      studentId: json['studentId'],
      username: json['username'],
      subjects: subjectsList,
      hasResults: json['hasResults'],
      average: (json['average'] as num).toDouble(),
    );
  }
}

class SubjectScore {
  final String subjectName;
  final double score;
  final String promotionStatus;
  final int examId;
  final int subjectId;
  final bool examExists;
  final bool subjectExists;
  final ResultData? resultData;

  SubjectScore({
    required this.subjectName,
    required this.score,
    required this.promotionStatus,
    required this.examId,
    required this.subjectId,
    required this.examExists,
    required this.subjectExists,
    this.resultData,
  });

  factory SubjectScore.fromJson(Map<String, dynamic> json) {
    return SubjectScore(
      subjectName: json['subjectName'],
      score: (json['score'] as num).toDouble(),
      promotionStatus: json['promotionStatus'],
      examId: json['examId'],
      subjectId: json['subjectId'],
      examExists: json['examExists'],
      subjectExists: json['subjectExists'],
      resultData: json['resultData'] != null
          ? ResultData.fromJson(json['resultData'])
          : null,
    );
  }
}

class ResultData {
  final int studentId;
  final int examId;

  ResultData({
    required this.studentId,
    required this.examId,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      studentId: json['student_id'],
      examId: json['exam_id'],
    );
  }
}

class RankedStudent {
  final int studentId;
  final String username;
  final double average;
  final int resultsCount;

  RankedStudent({
    required this.studentId,
    required this.username,
    required this.average,
    required this.resultsCount,
  });

  factory RankedStudent.fromJson(Map<String, dynamic> json) {
    return RankedStudent(
      studentId: json['studentId'],
      username: json['username'],
      average: (json['average'] as num).toDouble(),
      resultsCount: json['resultsCount'],
    );
  }
}

class DepartmentRanking {
  final String departmentName;
  final List<RankedStudent> students;

  DepartmentRanking({
    required this.departmentName,
    required this.students,
  });

  factory DepartmentRanking.fromJson(Map<String, dynamic> json) {
    final studentsList = json['students'] as List<dynamic>;
    return DepartmentRanking(
      departmentName: json['departmentName'],
      students: studentsList
          .map((studentJson) => RankedStudent.fromJson(studentJson))
          .toList(),
    );
  }
}
