import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

class VideoStorageService {
  Future<List<File>> getSavedVideos() async {
    final dir = await getApplicationDocumentsDirectory();
    final directory = Directory(dir.path);

    final List<File> videoFiles = [];

    final List<FileSystemEntity> entities = directory.listSync(recursive: true);

    for (var entity in entities) {
      if (entity is File) {
        final path = entity.path.toLowerCase();

        if (path.endsWith('.mp4') || path.endsWith('.mov')) {
          // To‘g‘ridan-to‘g‘ri qo‘shamiz
          videoFiles.add(entity);
        } else if (path.endsWith('.m3u8')) {
          // .m3u8 faylni mp4 ga konvertatsiya qilamiz
          try {
            final mp4File = await _convertM3u8ToMp4(entity);
            if (mp4File != null && await mp4File.exists()) {
              videoFiles.add(mp4File);
            }
          } catch (e) {
            print('Konvertatsiya xatoligi: $e');
          }
        }
      }
    }

    return videoFiles;
  }

  Future<File?> _convertM3u8ToMp4(File m3u8File) async {
    final mp4Path = m3u8File.path.replaceAll('.m3u8', '.mp4');
    final session = await FFmpegKit.execute(
      '-i "${m3u8File.path}" -c copy "$mp4Path"',
    );

    final returnCode = await session.getReturnCode();
    if (returnCode?.isValueSuccess() ?? false) {
      print('✅ ${m3u8File.path} konvertatsiya qilindi: $mp4Path');
      return File(mp4Path);
    } else {
      print('❌ Konvertatsiya muammosi: $mp4Path');
      return null;
    }
  }
}
