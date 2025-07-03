import 'package:dio/dio.dart';
import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:eduction_system/model/ExamModel.dart';
import 'package:eduction_system/model/MessageModel.dart';
import 'package:eduction_system/model/QuestionModel.dart';
import 'package:eduction_system/model/studentAnswerModel.dart';
import 'package:eduction_system/model/subjectModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StudentController extends GetxController {
  fetchExamDetailsById(int subjectId);
  submitAnswers(int examId, List<studentAnswerModel> answers);
  fetchQuestionsByExam(int examId);
  fetchStudentAverage(int studentId, int academicYear);
  fetchSubjectsByStudent();
  fetchInboxMessages();
}

class StudentControllerImp extends StudentController {
  List<SubjectModel> subjects = [];
  List<ExamModel> exams = [];
  List<QuestionModel> examQuestions = [];
  List<MessageModel> inboxMessages = [];

  bool isLoading = false;
  double average = 0;

  @override
  Future<void> fetchQuestionsByExam(int examId) async {
    isLoading = true;
    update();

    try {
      ApiClient apiClient = ApiClient();
      ApiResponse response = await apiClient.getData(
        url: '${ServerConfig().serverLink}/exams/$examId/questions',
      );

      if (response.statusCode == 200) {
        final body = response.data;
        print("📄 Raw questions data: $body");

        if (body is Map<String, dynamic> && body.containsKey('questions')) {
          final questionsList = body['questions'];
          if (questionsList is List) {
            examQuestions = questionsList
                .map(
                    (e) => QuestionModel.fromJson(Map<String, dynamic>.from(e)))
                .toList();
            print("✔️ تم تحميل ${examQuestions.length} سؤال");
          } else {
            Get.snackbar("خطأ", "قيمة 'questions' ليست قائمة.");
            examQuestions = [];
          }
        } else {
          Get.snackbar("خطأ", "البيانات لا تحتوي على 'questions'.");
          examQuestions = [];
        }
      } else {
        Get.snackbar("خطأ", "فشل في تحميل الأسئلة: ${response.statusCode}");
        examQuestions = [];
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء تحميل الأسئلة");
      print("❌ Exception: $e");
      examQuestions = [];
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  @override
  Future<int> submitAnswers(
      int examId, List<studentAnswerModel> answers) async {
    try {
      ApiClient apiClient = ApiClient();

      // جلب التوكن من SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      // تحضير الهيدر مع التوكن
      final headers = {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      };

      // إرسال البيانات مع الهيدر
      ApiResponse response = await apiClient.postData(
        url: '${ServerConfig().serverLink}/exams/$examId/submit',
        data: {
          "answers": answers.map((a) => a.toJson()).toList(),
        },
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("📤 تم إرسال الإجابات: ${response.data}");
        return response.data['score'] ?? 0;
      } else if (response.statusCode == 400) {
        // حالة تقديم الامتحان مسبقًا
        throw Exception("400: لقد قدمت هذا الامتحان مسبقًا.");
      } else {
        Get.snackbar("خطأ", "فشل في إرسال الإجابات: ${response.statusCode}");
        return 0;
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء إرسال الإجابات");
      print("❌ Exception: $e");
      rethrow; // مهم نعيد رمي الاستثناء علشان نعالجه برا
    }
  }

  @override
  Future<void> fetchExamDetailsById(int subjectId) async {
    isLoading = true;
    update();

    try {
      ApiClient apiClient = ApiClient();
      ApiResponse response = await apiClient.getData(
        url:
            '${ServerConfig().serverLink}/exams/subject/$subjectId', // لاحظ رابط الـ API الجديد
      );

      if (response.statusCode == 200) {
        final body = response.data;
        print("📄 Raw exams data: $body");

        if (body is List) {
          exams = body.map((e) => ExamModel.fromJson(e)).toList();
        } else {
          Get.snackbar("خطأ", "بيانات غير متوقعة من السيرفر.");
          exams = [];
        }

        print("✔️ تم تحميل ${exams.length} امتحان");
      } else {
        Get.snackbar("خطأ", "فشل في تحميل الامتحانات: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء تحميل الامتحانات");
      print("❌ Exception: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  Future<double?> fetchStudentAverage(int studentId, int academicYear) async {
    try {
      ApiClient apiClient = ApiClient();
      ApiResponse response = await apiClient.getData(
        url:
            '${ServerConfig().serverLink}/exams/average/$studentId/$academicYear',
      );

      if (response.statusCode == 200) {
        final body = response.data;
        // من المفترض هيك شكل الداتا حسب المثال اللي أعطيت
        double average = (body['average'] as num).toDouble();
        return average;
      } else {
        Get.snackbar("خطأ", "فشل في تحميل المعدل");
        return null;
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء تحميل المعدل");
      print("❌ Exception: $e");
      return null;
    }
  }

  Future<void> sendMessageToDoctorDirect({
    required int studentId,
    required int doctorId,
    required String messageText,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('❌ لا يوجد توكن في SharedPreferences');
      Get.snackbar(
        'خطأ',
        'لم يتم العثور على التوكن. يرجى تسجيل الدخول من جديد.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final dio = Dio();

    try {
      final response = await dio.post(
        '${ServerConfig().serverLink}/messages/send',
        data: {
          "student_id": studentId,
          "doctor_id": doctorId,
          "message_text": messageText,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ تم إرسال الرسالة للدكتور $doctorId');
        Get.snackbar(
          'تم الإرسال',
          'تم إرسال الرسالة بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print('❌ فشل إرسال الرسالة: ${response.data}');
        Get.snackbar(
          'فشل',
          'حدث خطأ أثناء إرسال الرسالة',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ خطأ أثناء إرسال الرسالة: $e');
      Get.snackbar(
        'خطأ',
        'تعذر الاتصال بالخادم',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Future<void> fetchSubjectsByStudent() async {
    ApiClient apiClient = ApiClient();
    isLoading = true;
    update();

    try {
      ApiResponse response = await apiClient.getData(
        url: '${ServerConfig().serverLink}/subjects/student',
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          Map<String, dynamic> data = Map<String, dynamic>.from(response.data);

          if (data.containsKey('subjects')) {
            List<dynamic> subjectList = data['subjects'];

            if (subjectList.isNotEmpty) {
              // فلترة العناصر اللي مش null قبل التحويل
              subjects = subjectList
                  .where((json) => json != null)
                  .map((json) =>
                      SubjectModel.fromJson(Map<String, dynamic>.from(json)))
                  .toList();
              print("✔️ تم تحميل ${subjects.length} مادة للطالب");
            } else {
              print("قائمة المواد فارغة");
              subjects = [];
            }
          } else {
            print("لا يوجد حقل 'subjects' في البيانات");
            subjects = [];
          }
        } else {
          print("بيانات غير متوقعة من السيرفر أو ليست Map<String, dynamic>");
          subjects = [];
        }
      } else {
        Get.snackbar("خطأ", "فشل في تحميل المواد: ${response.statusCode}");
        subjects = [];
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء جلب بيانات المواد");
      print("Exception during fetchSubjectsByStudent: $e");
      subjects = [];
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  Future<void> fetchInboxMessages() async {
    isLoading = true;
    update();

    try {
      ApiClient apiClient = ApiClient();

      ApiResponse response = await apiClient.getData(
        url: '${ServerConfig().serverLink}/messages/student/messages',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print("📥 Raw inbox: $data");

        if (data is List) {
          inboxMessages = data.map((e) => MessageModel.fromJson(e)).toList();
          print("✔️ تم تحميل ${inboxMessages.length} رسالة");
        } else {
          Get.snackbar("خطأ", "بيانات غير متوقعة من السيرفر");
          inboxMessages = [];
        }
      } else {
        Get.snackbar("خطأ", "فشل تحميل الرسائل: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception while loading messages: $e");
      Get.snackbar("خطأ", "حدث خطأ أثناء تحميل الرسائل");
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    fetchInboxMessages();

    super.onInit();
  }
}
