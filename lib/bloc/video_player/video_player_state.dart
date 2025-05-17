abstract class VideoPlayerState {}

class VideoPlayerInitialState extends VideoPlayerState {}

class VideoPlayerLoadingState extends VideoPlayerState {}

class VideoPlayerLoadedState extends VideoPlayerState {
  final double? videoSizeInMb;

  VideoPlayerLoadedState({this.videoSizeInMb});
}

class VideoPlayerErrorState extends VideoPlayerState {
  final String message;
  VideoPlayerErrorState({required this.message});
}
