import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/core/theme/apptext_styles.dart';
import 'package:flutter_application_1/models/video_model.dart';
import 'package:flutter_application_1/views/pages/video_player_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 20),
          itemCount: fakeVideos.length,
          itemBuilder: (ctx, index) {
            final VideoModel videoModel = fakeVideos[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (ctx) => VideoPlayerPage(
                          url: videoModel.path,
                          title: videoModel.title,
                        ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(color: AppColors.onPrimary),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 150,
                      child: Image.network(
                        videoModel.coverPhoto,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            maxLines: 2,
                            videoModel.title,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.headlineMedium,
                          ),
                          Text("Davomiyligi - ${videoModel.duration}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
