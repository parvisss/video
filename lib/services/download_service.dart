import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
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
      await downloadHLS(
        m3u8Url: url,
        outputFilePath: filePath,
        onProgress: onProgress,
      );
    }

    return filePath;
  }

  Future<void> downloadHLS({
    required String m3u8Url,
    required String outputFilePath,
    required Function(int progress) onProgress,
  }) async {
    final dio = Dio();
    final cancelToken = CancelToken();

    try {
      final Uri masterUri = Uri.parse(m3u8Url);

      // 🔹 Master m3u8 faylni o‘qiymiz
      final response = await dio.get(m3u8Url, cancelToken: cancelToken);
      final lines = response.data.toString().split('\n');

      // 🔹 Variantlar ro‘yxatini ajratib olamiz
      final variantLines =
          lines
              .where((line) => line.trim().isNotEmpty && !line.startsWith('#'))
              .toList();

      if (variantLines.isEmpty) {
        throw Exception("No variant found in master .m3u8");
      }

      // 🔹 Birinchi variant playlistni tanlaymiz
      final variantUrl = masterUri.resolve(variantLines.first).toString();

      // 🔹 Segment playlistni o‘qiymiz
      final segmentPlaylistResponse = await dio.get(variantUrl);
      final segmentLines = segmentPlaylistResponse.data.toString().split('\n');

      final tsUrls =
          segmentLines
              .where((line) => line.trim().isNotEmpty && !line.startsWith('#'))
              .map((line) => masterUri.resolve(line).toString())
              .toList();

      if (tsUrls.isEmpty) throw Exception("No .ts segments found in playlist");

      // 🔹 Segmentlarni yuklab, bitta faylga yozamiz
      final outputFile = File(outputFilePath);
      if (await outputFile.exists()) {
        await outputFile.delete();
      }
      final sink = outputFile.openWrite(mode: FileMode.append);

      for (int i = 0; i < tsUrls.length; i++) {
        final segmentUrl = tsUrls[i];
        final segmentResponse = await dio.get<List<int>>(
          segmentUrl,
          options: Options(responseType: ResponseType.bytes),
        );

        sink.add(segmentResponse.data!);
        final progress = ((i + 1) / tsUrls.length * 100).floor();
        onProgress(progress);
      }

      await sink.close();
      print('✅ HLS video to‘liq saqlandi: $outputFilePath');
    } catch (e) {
      print('❌ HLS yuklashda xatolik: $e');
      rethrow;
    }
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

  Future<String> convertTsToMp4(String tsFilePath) async {
    final mp4FilePath = tsFilePath.replaceAll('.ts', '.mp4');

    final session = await FFmpegKit.execute(
      '-i "$tsFilePath" -c copy "$mp4FilePath"',
    );

    final returnCode = await session.getReturnCode();
    if (returnCode?.isValueSuccess() ?? false) {
      print('✅ Konvertatsiya tugadi: $mp4FilePath');
      return mp4FilePath;
    } else {
      print('❌ Konvertatsiya xatoligi');
      throw Exception('Konvertatsiya muammosi: $returnCode');
    }
  }
}
