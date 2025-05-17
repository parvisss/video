import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/services/video_storage_service.dart';
import 'saved_videos_event.dart';
import 'saved_videos_state.dart';

class SavedVideosBloc extends Bloc<SavedVideosEvent, SavedVideosState> {
  final VideoStorageService _videoStorageService;

  SavedVideosBloc(this._videoStorageService) : super(SavedVideosInitial()) {
    on<LoadSavedVideosEvent>(_onLoadSavedVideos);
  }

  Future<void> _onLoadSavedVideos(
    LoadSavedVideosEvent event,
    Emitter<SavedVideosState> emit,
  ) async {
    emit(SavedVideosLoading());

    try {
      final videos = await _videoStorageService.getSavedVideos();
      emit(SavedVideosLoaded(videos: videos));
    } catch (e) {
      emit(SavedVideosError(message: e.toString()));
    }
  }
}
