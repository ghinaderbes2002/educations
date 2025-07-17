import 'package:get/get.dart';
import 'package:eduction_system/core/services/SharedPreferences.dart'; // مسار MyServices

class ServerConfig {
  static final ServerConfig _instance = ServerConfig._internal();
  factory ServerConfig() => _instance;
  ServerConfig._internal();

  static const String _key = "server_link";
  // String _serverLink = "http://192.168.74.19:8000/api";
  String _serverLink = "192.168.74.18"; //LAN ip

  String get serverLink => _serverLink;

  Future<void> loadServerLink() async {
    final myServices = Get.find<MyServices>();
    final savedLink = myServices.sharedPref.getString(_key);
    if (savedLink != null && savedLink.isNotEmpty) {
      _serverLink = savedLink;
    }
  }

  Future<void> updateServerLink(String newLink) async {
    _serverLink = newLink;
    final myServices = Get.find<MyServices>();
    await myServices.sharedPref.setString(_key, newLink);
  }

  Future<void> resetToDefault() async {
    _serverLink = "http://192.168.74.18:8000/api";
    final myServices = Get.find<MyServices>();
    await myServices.sharedPref.setString(_key, _serverLink);
  }
}
