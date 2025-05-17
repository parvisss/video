abstract class VideoPlayerEvent {}

class GetVideoEvent extends VideoPlayerEvent {
  final String url;
  GetVideoEvent({required this.url});
}
