import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiResponse<T> {
  final int statusCode;
  final T data;

  ApiResponse({required this.statusCode, required this.data});
}

class ApiClient {
  final Dio _dio = Dio();

  


  Future<ApiResponse<dynamic>> patchData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      print("Attempting to patch data to $url with data: $data");

      // ✅ استرجاع SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // ✅ استرجاع التوكن
      final token = prefs.getString('token');

      // ✅ بناء الهيدر
      final defaultHeaders = {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        if (headers != null) ...headers,
      };

      var response = await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: defaultHeaders),
      );

      print(
          "Data patched successfully with status code ${response.statusCode}");
      return ApiResponse(
        statusCode: response.statusCode!,
        data: response.data,
      );
    } catch (error, stacktrace) {
      print("Failed to patch data: $error");
      print("Stacktrace: $stacktrace");

      throw DioError(
        requestOptions: RequestOptions(path: url),
        error: 'Failed to patch data: $error',
      );
    }
  }

 Future<ApiResponse<dynamic>> postData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      print("Attempting to post data to $url with data: $data");
      print("Headers sent: $headers");

      var response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          validateStatus: (status) {
            // السماح بأي حالة رد بدون رمي استثناء
            return status != null && status >= 200 && status < 500;
          },
        ),
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      return ApiResponse(statusCode: response.statusCode!, data: response.data);
    } catch (error, stacktrace) {
      print("Failed to post data: $error");
      print("Stacktrace: $stacktrace");
      rethrow;
    }
  }


  Future<ApiResponse<dynamic>> getData({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      print("Attempting to GET data from $url");

      // ✅ استرجاع SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // ✅ استرجاع التوكن من SharedPreferences
      final token = prefs.getString('token');

      // ✅ بناء الهيدر
      final defaultHeaders = {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        if (headers != null) ...headers,
      };

      var response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: defaultHeaders),
      );

      print("GET successful - Status Code: ${response.statusCode}");
      return ApiResponse(
        statusCode: response.statusCode!,
        data: response.data,
      );
    } catch (error, stacktrace) {
      print("Failed to GET data: $error");
      print("Stacktrace: $stacktrace");

      throw DioError(
        requestOptions: RequestOptions(path: url),
        error: 'Failed to fetch data: $error',
      );
    }
  }

Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }


Future<ApiResponse<dynamic>> deleteData({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      // جلب التوكن
      String? token =
          await getToken(); // إذا عندك دالة تجيب التوكن من SharedPreferences

      // إعداد الهيدر
      final effectiveHeaders = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        ...?headers, // إذا أرسل هيدر من برا يدمجه
      };

      print("🟡 DELETE to $url with headers: $effectiveHeaders");

      Response<dynamic> response = await _dio.delete(
        url,
        queryParameters: queryParameters,
        options: Options(headers: effectiveHeaders),
      );

      print("✅ Data deleted with status code ${response.statusCode}");
      return ApiResponse(statusCode: response.statusCode!, data: response.data);
    } catch (error, stacktrace) {
      print("❌ Failed to delete data: $error");
      print("📌 Stacktrace: $stacktrace");
      throw DioError(
        requestOptions: RequestOptions(path: url),
        error: 'Failed to delete data: $error',
      );
    }
  }

  Future<ApiResponse<dynamic>> putData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      print("Attempting to put data to $url");
      Response<dynamic> response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      print("Data put successfully with status code ${response.statusCode}");
      return ApiResponse(statusCode: response.statusCode!, data: response.data);
    } catch (error, stacktrace) {
      print("Failed to put data: $error");
      print("Stacktrace: $stacktrace");
      throw DioError(
        requestOptions: RequestOptions(path: url),
        error: 'Failed to put data: $error',
      );
    }
  }
}
