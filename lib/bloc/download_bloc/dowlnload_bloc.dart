import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'download_event.dart';
import 'download_state.dart';
import '../../services/download_service.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final DownloadService _downloadService = DownloadService();

  String? _savedFilePath;

  DownloadBloc() : super(InitialVideoDownloadState()) {
    on<StartDownloadingEvent>(_onStartDownload);
    on<CancelDownloadEvent>(_onDownloadCancel);
    on<RemoveDownloadEvent>(_onRemoveDownload);
    on<CheckFileExistenceEvent>(_onCheckFileExistence);
  }

  Future<void> _onStartDownload(
    StartDownloadingEvent event,
    Emitter<DownloadState> emit,
  ) async {
    emit(DownloadingState(progress: 0));

    try {
      final filePath = await _downloadService.downloadFile(
        url: event.url,
        fileName: event.fileName,
        downloadType: event.downloadType,
        onProgress: (progress) {
          emit(DownloadingState(progress: progress));
        },
      );

      _savedFilePath = filePath;
      emit(DownloadSuccessState(filePath: filePath));
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        emit(DownloadCancelledState());
        emit(InitialVideoDownloadState());
      } else {
        emit(DownloadErrorState(message: e.toString()));
      }
    }
  }

  Future<void> _onDownloadCancel(
    CancelDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    _downloadService.cancelDownload();
  }

  Future<void> _onRemoveDownload(
    RemoveDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    if (_savedFilePath != null) {
      await _downloadService.deleteFile(_savedFilePath!);
    }
    _savedFilePath = null;
    emit(InitialVideoDownloadState());
  }

  Future<void> _onCheckFileExistence(
    CheckFileExistenceEvent event,
    Emitter<DownloadState> emit,
  ) async {
    final exists = await _downloadService.checkIfExists(
      event.fileName,
      event.downloadType,
    );

    final path = await _downloadService.getFilePath(
      event.fileName,
      event.downloadType,
    );

    if (exists) {
      _savedFilePath = path;
      emit(DownloadSuccessState(filePath: path));
    } else {
      emit(InitialVideoDownloadState());
    }
  }
}
