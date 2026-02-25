import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/youtube_video_card.dart';
import 'package:pub_dev_packages_app/features/widgets/shimmer_box.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeVideosSection extends StatelessWidget {
  final List<Video> playlist;
  final bool isLoading;

  const YoutubeVideosSection({
    super.key,
    required this.playlist,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _ShimmerYoutubeVideos();
    } else if (playlist.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SizedBox(
          height: 210.h,
          child: CarouselSlider.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index, realIndex) {
              final video = playlist[index];
              return YoutubeVideoCard(
                title: video.title,
                thumbnail: video.thumbnails.highResUrl,
                videoUrl: video.url,
              );
            },
            options: CarouselOptions(autoPlay: true, clipBehavior: Clip.none),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _ShimmerYoutubeVideos extends StatelessWidget {
  const _ShimmerYoutubeVideos();

  @override
  Widget build(BuildContext context) {
    final widths = [0.35.sw, 0.50.sw, 0.55.sw];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 210.h,
        child: CarouselSlider.builder(
          itemCount: 4,
          itemBuilder: (context, index, realIndex) {
            return Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(height: 157.h, width: double.infinity),
                  12.verticalSpace,
                  ShimmerBox(
                    height: 20.h,
                    width: index < widths.length ? widths[index] : 0.60.sw,
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(autoPlay: true, clipBehavior: Clip.none),
        ),
      ),
    );
  }
}
