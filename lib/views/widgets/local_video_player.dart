import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/my_chewie_controller.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer extends StatefulWidget {
  final File file;

  const LocalVideoPlayer({super.key, required this.file});

  @override
  State<LocalVideoPlayer> createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Chewie(
            controller:
                MyChewieController(
                  videoPlayerController: _controller,
                  autoplay: false,
                ).controller,
          ),
        )
        : Center(child: CircularProgressIndicator());
  }
}
