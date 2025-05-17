import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_application_1/bloc/download_bloc/download_event.dart';

extension FilePathExtension on String {
  /// Get full file path for download type
  Future<String> toFilePath(DownloadType type) async {
    final dir = await getApplicationDocumentsDirectory();
    final ext = type == DownloadType.mp4 ? '.mp4' : '.m3u8';
    return "${dir.path}/$this$ext";
  }

  /// Check if file exists
  Future<bool> fileExists(DownloadType type) async {
    final path = await toFilePath(type);
    return File(path).exists();
  }

  /// Get File object
  Future<File> toFile(DownloadType type) async {
    final path = await toFilePath(type);
    return File(path);
  }
}
