import 'package:dio/dio.dart';
import 'package:snib_order_tracking_app/core/network/apiHelper/api_endpoint.dart';
import 'package:snib_order_tracking_app/core/network/dioClient/dio_client.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<void> loginUser(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndPoint.loginApi,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        print("🎉 Login successful: ${response.data}");
      } else {
        print("⚠️ Unexpected status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("🔴 Dio error response: ${e.response?.data}");
      } else {
        print("🔴 Dio error message: ${e.message}");
      }
    }
  }
}