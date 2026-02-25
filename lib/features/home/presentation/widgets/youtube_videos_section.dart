import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/youtube_video_card.dart';
import 'package:pub_dev_packages_app/features/widgets/shimmer_box.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeVideosSection extends StatelessWidget {
  final List<Video> playlist;
  final bool isLoading; // Add this

  const YoutubeVideosSection({
    super.key, 
    required this.playlist, 
    required this.isLoading, // Pass it here
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const ShimmerYoutubeVideos();
    } else if (playlist.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SizedBox(
          height: 255.h,
          child: CarouselSlider.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index, realIndex) {
              final video = playlist[index];
              return YoutubeVideoCard(
                title: video.title,
                thumbnail: video.thumbnails.highResUrl,
              );
            },
            options: CarouselOptions(
              height: 255.h,
              autoPlay: true,
              clipBehavior: Clip.none,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class ShimmerYoutubeVideos extends StatelessWidget {
  const ShimmerYoutubeVideos({super.key});

  @override
  Widget build(BuildContext context) {
    final widths = [0.35.sw, 0.50.sw, 0.55.sw];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 255.h,
        child: CarouselSlider.builder(
          itemCount: 4,
          itemBuilder: (context, index, realIndex) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 200.h, width: 0.7.sw),
                12.verticalSpace,
                ShimmerBox(
                  height: 20.h,
                  width: index < widths.length ? widths[index] : 0.60.sw,
                ),
              ],
            );
          },
          options: CarouselOptions(
            height: 255.h,
            autoPlay: true,
            clipBehavior: Clip.none,
          ),
        ),
      ),
    );
  }
}
