import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/saved_videos/saved_videos_bloc.dart';
import 'package:flutter_application_1/bloc/saved_videos/saved_videos_event.dart';
import 'package:flutter_application_1/bloc/saved_videos/saved_videos_state.dart';
import 'package:flutter_application_1/views/widgets/local_video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedVideosScreen extends StatefulWidget {
  const SavedVideosScreen({super.key});

  @override
  State<SavedVideosScreen> createState() => _SavedVideosScreenState();
}

class _SavedVideosScreenState extends State<SavedVideosScreen> {
  @override
  void initState() {
    context.read<SavedVideosBloc>().add(LoadSavedVideosEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SavedVideosBloc, SavedVideosState>(
        builder: (context, state) {
          if (state is SavedVideosLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SavedVideosLoaded) {
            final videos = state.videos;
            if (videos.isEmpty) {
              return Center(child: Text('Videolar topilmadi.'));
            }

            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [LocalVideoPlayer(file: video)],
                  ),
                );
              },
            );
          } else if (state is SavedVideosError) {
            return Center(child: Text('Xatolik: ${state.message}'));
          }

          return Center(child: Text('Videolarni yuklash uchun tugma bosing'));
        },
      ),
    );
  }
}
