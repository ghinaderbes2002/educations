import 'package:eduction_system/core/services/SharedPreferences.dart';
import 'package:eduction_system/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkUtils {
  static Future<String> getLocalIPv4() async {
    final info = NetworkInfo();
    final wifiIP = await info.getWifiIP();
    return wifiIP ?? "Not found";
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  // final ip = await NetworkUtils.getLocalIPv4();
  // print("🌐 LAN IP: $ip");
  // await ServerConfig().updateServerLink(ip);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      getPages: routes,
    );
  }
}
