import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/download_bloc/dowlnload_bloc.dart';
import 'package:flutter_application_1/views/widgets/online_video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/bloc/video_player/video_player_bloc.dart';
import 'package:flutter_application_1/bloc/video_player/video_player_event.dart';
import 'package:flutter_application_1/bloc/video_player/video_player_state.dart';
import 'package:flutter_application_1/bloc/download_bloc/download_event.dart';
import 'package:flutter_application_1/bloc/download_bloc/download_state.dart';
import 'package:flutter_application_1/controllers/my_chewie_controller.dart';
import 'package:flutter_application_1/core/theme/app_icons.dart';

class VideoPlayerPage extends StatefulWidget {
  final String url;
  final String title;

  const VideoPlayerPage({super.key, required this.url, required this.title});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  MyChewieController? _myChewieController;

  @override
  void initState() {
    context.read<VideoPlayerBloc>().add(GetVideoEvent(url: widget.url));

    super.initState();
  }

  @override
  void dispose() {
    _myChewieController?.dispose();
    super.dispose();
  }

  DownloadType _getDownloadType(String url) {
    if (url.endsWith(".mp4")) return DownloadType.mp4;
    if (url.endsWith(".m3u8")) return DownloadType.hls;
    return DownloadType.mp4; // fallback
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DownloadBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: SafeArea(
          child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
            builder: (context, state) {
              if (state is VideoPlayerLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is VideoPlayerErrorState) {
                return Center(child: Text(state.message));
              }
              if (state is VideoPlayerLoadedState) {
                context.read<DownloadBloc>().add(
                  CheckFileExistenceEvent(
                    fileName: widget.title,
                    downloadType: _getDownloadType(widget.url),
                  ),
                );
                return Column(
                  children: [
                    OnlineVideoPlayer(url: widget.url),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocBuilder<DownloadBloc, DownloadState>(
                            builder: (context, downloadState) {
                              if (downloadState is DownloadingState) {
                                return Row(
                                  children: [
                                    Text(
                                      "${downloadState.progress}%",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                        IconButton(
                                          icon: const Icon(AppIcons.cancel),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder:
                                                  (ctx) => _buildCancelSheet(
                                                    context,
                                                  ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }

                              if (downloadState is DownloadSuccessState) {
                                return IconButton(
                                  icon: const Icon(AppIcons.delete),
                                  onPressed: () {
                                    context.read<DownloadBloc>().add(
                                      RemoveDownloadEvent(),
                                    );
                                  },
                                );
                              }

                              return IconButton(
                                icon: Icon(AppIcons.download),
                                onPressed: () {
                                  context.read<DownloadBloc>().add(
                                    StartDownloadingEvent(
                                      url: widget.url,
                                      fileName: widget.title,
                                      downloadType: _getDownloadType(
                                        widget.url,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: Text("No video"));
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildCancelSheet(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Yuklab olishni bekor qilmoqchimisiz?",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Yo‘q"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<DownloadBloc>().add(CancelDownloadEvent());
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Ha"),
            ),
          ],
        ),
      ],
    ),
  );
}
