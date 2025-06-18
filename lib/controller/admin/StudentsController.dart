import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/userModel.dart';

abstract class StudentsController extends GetxController {
  addStudent();
  updateStudent(UserModel updated);
  deleteStudent(int id);
}

class StudentsControllerImp extends StudentsController {
  // كنترولرات للإدخال
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // الطلاب
  List<UserModel> students = [];

  // لتحديد هل تعديل أم إضافة جديدة
  UserModel? editingStudent;

  @override
  void addStudent() {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar("خطأ", "يرجى ملء كل الحقول");
      return;
    }

    if (editingStudent == null) {
      students.add(
        UserModel(
          user_id: students.length + 1,
          username: nameController.text,
          phone: phoneController.text,
          password: passwordController.text,
          role: "student",
        ),
      );
    } else {
      int index = students.indexWhere((s) => s.user_id == editingStudent!.user_id);
      students[index] = editingStudent!.copyWith(
        username: nameController.text,
        phone: phoneController.text,
        password: passwordController.text,
      );
      editingStudent = null;
    }

    nameController.clear();
    phoneController.clear();
    passwordController.clear();
    update();
  }

  @override
  void updateStudent(UserModel student) {
    editingStudent = student;
    nameController.text = student.username!;
    phoneController.text = student.phone!;
    passwordController.text = student.password!;
    update();
  }

  @override
  void deleteStudent(int id) {
    students.removeWhere((s) => s.user_id == id);
    update();
  }
}
