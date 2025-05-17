import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/dio/dio_client.dart';
import 'package:flutter_application_1/extensions/file_path_extension.dart';
import 'package:flutter_application_1/bloc/download_bloc/download_event.dart';

class DownloadService {
  final Dio _dio = DioClient().dio;
  CancelToken? _cancelToken;

  void cancelDownload() {
    _cancelToken?.cancel("Download cancelled by user");
  }

  Future<String> downloadFile({
    required String url,
    required String fileName,
    required DownloadType downloadType,
    required Function(int progress) onProgress,
  }) async {
    final filePath = await fileName.toFilePath(downloadType);
    final file = File(filePath);

    if (await file.exists()) return filePath;

    _cancelToken = CancelToken();

    if (downloadType == DownloadType.mp4) {
      await _dio.download(
        url,
        filePath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).floor();
            onProgress(progress);
          }
        },
      );
    } else {
      await _dio.download(
        url,
        filePath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).floor();
            onProgress(progress);
          }
        },
      );
    }

    return filePath;
  }

  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<bool> checkIfExists(String fileName, DownloadType downloadType) async {
    return fileName.fileExists(downloadType);
  }

  Future<String> getFilePath(String fileName, DownloadType downloadType) async {
    return fileName.toFilePath(downloadType);
  }
}
