import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MyChewieController {
  final VideoPlayerController videoPlayerController;
  bool? autoplay;
  late ChewieController controller;

  MyChewieController({required this.videoPlayerController, this.autoplay}) {
    controller = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: autoplay ?? false,
      looping: false,
    );
  }

  void dispose() {
    controller.dispose();
    videoPlayerController.dispose();
  }
}
