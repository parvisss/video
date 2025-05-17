import 'package:equatable/equatable.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object?> get props => [];
}

class StartDownloadingEvent extends DownloadEvent {
  final String url;
  final String fileName;
  final DownloadType downloadType;

  const StartDownloadingEvent({
    required this.url,
    required this.fileName,
    required this.downloadType,
  });
}

class CheckFileExistenceEvent extends DownloadEvent {
  final String fileName;
  final DownloadType downloadType;

  const CheckFileExistenceEvent({
    required this.fileName,
    required this.downloadType,
  });
}

class CancelDownloadEvent extends DownloadEvent {}

class RemoveDownloadEvent extends DownloadEvent {}

enum DownloadType { mp4, hls }
