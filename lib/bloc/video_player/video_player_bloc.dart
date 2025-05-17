import 'package:flutter_application_1/bloc/video_player/video_player_event.dart';
import 'package:flutter_application_1/bloc/video_player/video_player_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerBloc() : super(VideoPlayerInitialState()) {
    on<GetVideoEvent>(_onGetVideo);
  }

  Future<void> _onGetVideo(
    GetVideoEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(VideoPlayerLoadingState());

    try {
      final dio = Dio();
      final response = await dio.head(event.url);

      final contentLengthHeader = response.headers.value('content-length');
      double? sizeInMB;
      if (contentLengthHeader != null) {
        final bytes = int.parse(contentLengthHeader);
        sizeInMB = bytes / (1024 * 1024);
      }

      final controller = VideoPlayerController.networkUrl(Uri.parse(event.url));
      await controller.initialize();

      emit(VideoPlayerLoadedState(videoSizeInMb: sizeInMB));
    } catch (e) {
      emit(VideoPlayerErrorState(message: e.toString()));
    }
  }
}
