import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/my_chewie_controller.dart';
import 'package:video_player/video_player.dart';

class OnlineVideoPlayer extends StatefulWidget {
  const OnlineVideoPlayer({super.key, required this.url});
  final String url;
  @override
  State<OnlineVideoPlayer> createState() => _OnlineVideoPlayerState();
}

class _OnlineVideoPlayerState extends State<OnlineVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.contentUri(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.3),
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Chewie(
          controller:
              MyChewieController(videoPlayerController: _controller).controller,
        ),
      ),
    );
  }
}
