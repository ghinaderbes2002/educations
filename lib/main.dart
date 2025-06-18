import 'package:eduction_system/controller/auth/StatsController.dart';
import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:eduction_system/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      getPages: routes,
    );
  }
}
