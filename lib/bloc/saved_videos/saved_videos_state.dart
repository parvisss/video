import 'dart:io';

abstract class SavedVideosState {}

class SavedVideosInitial extends SavedVideosState {}

class SavedVideosLoading extends SavedVideosState {}

class SavedVideosLoaded extends SavedVideosState {
  final List<File> videos;

  SavedVideosLoaded({required this.videos});
}

class SavedVideosError extends SavedVideosState {
  final String message;

  SavedVideosError({required this.message});
}
