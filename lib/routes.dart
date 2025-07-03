import 'package:eduction_system/core/constant/App_routes.dart';
import 'package:eduction_system/core/middleware/AuthMiddleware.dart';
import 'package:eduction_system/view/screen/OnboardingScreen.dart';
import 'package:eduction_system/view/screen/admin/DoctorsScreen.dart';
import 'package:eduction_system/view/screen/admin/ReportsScreen.dart';
import 'package:eduction_system/view/screen/admin/SubAdminScreen.dart';
import 'package:eduction_system/view/screen/admin/SubjectScreen.dart';
import 'package:eduction_system/view/screen/admin/department_screen.dart';
import 'package:eduction_system/view/screen/admin/mainHome.dart';
import 'package:eduction_system/view/screen/auth/login.dart';
import 'package:eduction_system/view/screen/auth/signUp.dart';
import 'package:eduction_system/view/screen/doctor/DoctorSubjects.dart';
import 'package:eduction_system/view/screen/sutdents/StudentSubjectsScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

List<GetPage<dynamic>>? routes = [

  // GetPage(
  //   name: "/",
  //   page: () => const AdminHomeScreen(),
  // ),

  // GetPage(
  //   name: "/",
  //   page: () =>  DoctorSubjectsScreen(),

  // ),

  
GetPage(
  name: '/',
  page: () => Container(), // ما بتنعرض أصلاً لأنه بيتم تحويله مباشرة
  middlewares: [AuthMiddleware()],
),

  GetPage(
  name: '/onboarding',
  page: () => OnboardingScreen(),
),




//  GetPage(
//     name: '/',
//     page: () => OnboardingScreen(),
//     middlewares: [
//       AuthMiddleware(),
//     ],
//   ),


  
  GetPage(
    name: AppRoute.signup,
    page: () => const SignUp(),
  ),

    GetPage(
    name: AppRoute.login,
    page: () => const Login(),
  ),

  GetPage(
    name: AppRoute.doctor,
    page: () => const DoctorsScreen(),
  ),

  GetPage(
    name: AppRoute.department,
    page: () => const DepartmentScreen(),
  ),

  GetPage(
    name: AppRoute.subject,
    page: () => const SubjectScreen(),
  ),


  GetPage(
    name: AppRoute.subAdmin,
    page: () =>  SubAdminScreen(),
  ),

   GetPage(
    name: AppRoute.reports,
    page: () => ReportsScreen(),
  ),

  //  GetPage(
  //   name: AppRoute.grades,
  //   page: () => const GradesScreen(),
  // ),


GetPage(name: '/admin_home', page: () => const AdminHomeScreen()),
GetPage(name: '/doctor_subjects', page: () => DoctorSubjectsScreen()),
GetPage(name: '/student_subjects', page: () => StudentSubjectsScreen()),


];

