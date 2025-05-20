import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';

class LocalVideoPlayer extends StatelessWidget {
  final File file;

  const LocalVideoPlayer({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return YoYoPlayer(
      url: file.path,
      aspectRatio: 16 / 9,
      videoStyle: VideoStyle(
        playIcon: Icon(Icons.play_arrow, size: 50),
        qualityStyle: const TextStyle(color: Colors.white),
      ),
      videoLoadingStyle: const VideoLoadingStyle(
        loading: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
