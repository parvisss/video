import 'package:dio/dio.dart';
import 'package:flutter_application_1/dio/dio_client.dart';

class VideoService {
  final Dio _dio = DioClient().dio;

  //video ni hajmini MB da olish
  Future<double?> fetchVideoSizeInMB(String url) async {
    try {
      final response = await _dio.head(url);
      final contentLength = response.headers.value('content-length');

      if (contentLength != null) {
        final bytes = int.parse(contentLength);
        return bytes / (1024 * 1024);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
