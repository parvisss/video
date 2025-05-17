import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/download_bloc/dowlnload_bloc.dart';
import 'package:flutter_application_1/bloc/saved_videos/saved_videos_bloc.dart';
import 'package:flutter_application_1/bloc/video_player/video_player_bloc.dart';
import 'package:flutter_application_1/services/video_storage_service.dart';
import 'package:flutter_application_1/views/widgets/main_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => VideoPlayerBloc()),
        BlocProvider(create: (context) => DownloadBloc()),
        BlocProvider(
          create: (context) => SavedVideosBloc(VideoStorageService()),
        ),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, home: MainLayout()),
    );
  }
}
