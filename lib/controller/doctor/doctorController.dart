import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:eduction_system/model/ExamModel.dart';
import 'package:eduction_system/model/MessageModel.dart';
import 'package:eduction_system/model/QuestionModel.dart';
import 'package:eduction_system/model/subjectModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DoctorController extends GetxController {
  fetchSubjectsbydoctor();
  fetchInboxMessages();
  fetchExamDetailsById(int subjectId);
  sendMessageToDoctorDirect({
    required int studentId,
    required int doctorId,
    required String messageText,
  });
}

class DoctorsControllerImp extends DoctorController {
  List<SubjectModel> subjects = [];
  List<ExamModel> exams = [];
  List<QuestionModel> examQuestions = [];
  List<MessageModel> inboxMessages = [];

  bool isLoadingMessages = false;
  bool isLoadingQuestions = false;
  bool isLoading = false;

  @override
  void onInit() {
    fetchSubjectsbydoctor();
    fetchInboxMessages();

    super.onInit();
  }

  @override
  Future<void> fetchSubjectsbydoctor() async {
    ApiClient apiClient = ApiClient();
    isLoading = true;
    update();

    try {
      final prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user');

      if (userJson == null) {
        Get.snackbar("خطأ", "لم يتم العثور على بيانات المستخدم");
        return;
      }

      final userMap = jsonDecode(userJson);
      print("📦 بيانات المستخدم المخزنة: $userMap");

      if (userMap["user_id"] == null) {
        Get.snackbar("خطأ", "معرف الدكتور غير موجود في البيانات");
        return;
      }

      final int doctorId = userMap["user_id"];

      ApiResponse response = await apiClient.getData(
        url: '${ServerConfig().serverLink}/users/doctors/$doctorId/subjects',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print("Raw subjects data: $data");

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
      update();
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
  Future<void> fetchInboxMessages() async {
    isLoadingMessages = true;
    update();

    try {
      ApiClient apiClient = ApiClient();

      ApiResponse response = await apiClient.getData(
        url: '${ServerConfig().serverLink}/messages/inbox',
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
      isLoadingMessages = false;
      update();
    }
  }

  @override
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
}
