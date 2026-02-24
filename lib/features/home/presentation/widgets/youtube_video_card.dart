import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/assets_gen/assets.gen.dart';

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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final assets = Assets.icons;

    return GestureDetector(
      onLongPressStart: (_) {
        setState(() {
          _isHovered = true;
        });
      },

      onLongPressEnd: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      // Keeps the UI safe if the gesture is canceled by the system
      onLongPressCancel: () {
        setState(() {
          _isHovered = false;
        });
      },

      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.thumbnail,
                    height: 150,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Image.asset(
                  _isHovered
                      ? assets.youtubePlayRed.path
                      : assets.youtubePlayBlack.path,
                  width: 60.w,
                  height: 60.h,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
