import 'package:equatable/equatable.dart';

abstract class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object?> get props => [];
}

class InitialVideoDownloadState extends DownloadState {}

class DownloadingState extends DownloadState {
  final int progress; // 0 - 100

  const DownloadingState({required this.progress});

  @override
  List<Object?> get props => [progress];
}

class DownloadSuccessState extends DownloadState {
  final String filePath;

  const DownloadSuccessState({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class DownloadCancelledState extends DownloadState {}

class DownloadErrorState extends DownloadState {
  final String message;

  const DownloadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
