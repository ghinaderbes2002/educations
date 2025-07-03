import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final myServices = Get.find<MyServices>();
    final isLoggedIn = myServices.sharedPref.getBool("isLoggedIn") ?? false;
    int  step = myServices.sharedPref.getInt("step") ?? 4;


    print(isLoggedIn);

    // مش مسجل دخول → رجّعو على Onboarding
    if (!isLoggedIn) {
      return const RouteSettings(name: '/onboarding');
    }

    // مسجل دخول → رجّعو حسب الـ step
    if (step == 1) {
      return const RouteSettings(name: '/admin_home');
    } else if (step == 2) {
      return const RouteSettings(name: '/doctor_subjects');
    } else if (step == 3) {
      return const RouteSettings(name: '/student_subjects');
    } 

    // ما في تحويل، كمل طبيعي
    return null;
  }
}
