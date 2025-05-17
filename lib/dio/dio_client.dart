import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  late final Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {"Accept": "application/json"},
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}
