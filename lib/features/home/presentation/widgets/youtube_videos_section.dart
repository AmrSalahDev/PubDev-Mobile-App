import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_bloc.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_state.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/youtube_video_card.dart';

class YoutubeVideosSection extends StatelessWidget {
  const YoutubeVideosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackagesBloc, PackagesState>(
      builder: (context, state) {
        if (state.isYoutubeVideosLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.youtubeVideos.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 255.h,
              child: CarouselSlider.builder(
                itemCount: state.youtubeVideos.length,
                itemBuilder: (context, index, realIndex) {
                  final video = state.youtubeVideos[index];
                  return YoutubeVideoCard(
                    title: video.title,
                    // Use the high-res thumbnail from the video object
                    thumbnail: video.thumbnails.highResUrl,
                  );
                },
                options: CarouselOptions(
                  height: 255.h,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
