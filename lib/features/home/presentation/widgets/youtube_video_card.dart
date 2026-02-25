import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/assets_gen/assets.gen.dart';
import 'package:pub_dev_packages_app/features/widgets/shimmer_image.dart';

class YoutubeVideoCard extends StatefulWidget {
  final String title;
  final String thumbnail;
  const YoutubeVideoCard({
    super.key,
    required this.title,
    required this.thumbnail,
  });

  @override
  State<YoutubeVideoCard> createState() => _YoutubeVideoCardState();
}

class _YoutubeVideoCardState extends State<YoutubeVideoCard> {
  bool _isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    final assets = Assets.icons;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onLongPressStart: (_) {
        setState(() {
          _isLongPressed = true;
        });
      },

      onLongPressEnd: (_) {
        setState(() {
          _isLongPressed = false;
        });
      },
      // Keeps the UI safe if the gesture is canceled by the system
      onLongPressCancel: () {
        setState(() {
          _isLongPressed = false;
        });
      },

      child: Container(
        margin: EdgeInsets.only(right: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ShimmerImage(
                  imageUrl: widget.thumbnail,
                  height: 200.h,
                  width: 0.7.sw,
                  borderRadius: 12.r,
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  _isLongPressed
                      ? assets.youtubePlayRed.path
                      : assets.youtubePlayBlack.path,
                  width: 60.w,
                  height: 60.h,
                ),
              ],
            ),
            10.verticalSpace,
            Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
