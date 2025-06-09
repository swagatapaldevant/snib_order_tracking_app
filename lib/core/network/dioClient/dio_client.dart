import 'package:dio/dio.dart';
import 'package:snib_order_tracking_app/core/network/apiHelper/api_endpoint.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoint.baseurl, // Change to your base URL
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        sendTimeout: Duration(seconds: 10),
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _initializeInterceptors();
  }

  Dio get dio => _dio;

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Optional: add auth token here
          // options.headers['Authorization'] = 'Bearer YOUR_TOKEN';
          print('➡️ REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('❌ ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}
