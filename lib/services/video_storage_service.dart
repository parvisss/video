import 'dart:io';
import 'package:path_provider/path_provider.dart';

class VideoStorageService {
  Future<List<File>> getSavedVideos() async {
    final dir = await getApplicationDocumentsDirectory();
    final directory = Directory(dir.path);

    final List<File> videoFiles = [];

    final List<FileSystemEntity> entities = directory.listSync(recursive: true);

    for (var entity in entities) {
      if (entity is File) {
        final path = entity.path.toLowerCase();
        if (path.endsWith('.mp4') ||
            path.endsWith('.ts') ||
            path.endsWith('.mov')) {
          videoFiles.add(entity);
        }
      }
    }

    return videoFiles;
  }
}
