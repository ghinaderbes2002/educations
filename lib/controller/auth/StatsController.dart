import 'package:eduction_system/core/classes/api_client.dart';
import 'package:eduction_system/core/constant/App_link.dart';
import 'package:get/get.dart';

class StatsController extends GetxController {
  int subjectsCount = 0;
  int doctorsCount = 0;
  int departmentsCount = 0;

  @override
  void onInit() {
    super.onInit();
    fetchAllStats();
  }

  Future<void> fetchAllStats() async {
    ApiClient apiClient = ApiClient();

    try {
      final subjectsResponse =
          await apiClient.getData(url: '$serverLink/subjects/count');
      final doctorsResponse =
          await apiClient.getData(url: '$serverLink/users/doctors/count');
      final departmentsResponse =
          await apiClient.getData(url: '$serverLink/departments/count');

      if (subjectsResponse.statusCode == 200) {
        subjectsCount = subjectsResponse.data['count'] ?? 0;
      }

      if (doctorsResponse.statusCode == 200) {
        doctorsCount = doctorsResponse.data['count'] ?? 0;
      }

      if (departmentsResponse.statusCode == 200) {
        departmentsCount = departmentsResponse.data['count'] ?? 0;
      }

      update(); // ✅ تحديث الواجهة مرة وحدة فقط
    } catch (e) {
      print("❌ Error fetching stats: $e");
    }
  }
}
