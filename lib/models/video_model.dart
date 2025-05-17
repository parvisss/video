class VideoModel {
  final num id;
  final String path;
  final String title;
  final String coverPhoto;
  final String duration;

  VideoModel({
    required this.id,
    required this.path,
    required this.title,
    required this.coverPhoto,
    required this.duration,
  });

  VideoModel copyWith({
    num? id,
    String? path,
    String? coverPhoto,
    String? title,
    String? duration,
  }) {
    return VideoModel(
      id: id ?? this.id,
      path: path ?? this.path,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      title: title ?? this.title,
      duration: duration ?? this.duration,
    );
  }

  @override
  String toString() => 'VideoModel(id: $id, path: $path)';
}

final List<VideoModel> fakeVideos = [
  VideoModel(
    id: 1,
    path:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    title: 'Big Buck Bunny',
    coverPhoto:
        'https://th.bing.com/th/id/OIP.EU22LIp-_ltTZeSe0a-n9AAAAA?rs=1&pid=ImgDetMain',
    duration: '00:09:56',
  ),
  VideoModel(
    id: 2,
    path: 'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8',
    title: 'Sintel',
    coverPhoto: 'https://i.ytimg.com/vi/MeFoUwes8nE/maxresdefault.jpg',
    duration: '00:14:48',
  ),
];
