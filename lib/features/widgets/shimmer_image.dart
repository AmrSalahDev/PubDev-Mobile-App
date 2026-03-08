import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pub_dev_packages_app/features/widgets/shimmer_box.dart';

class ShimmerImage extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final double borderRadius;
  final BoxFit fit;
  final Alignment alignment;

  const ShimmerImage({
    super.key,
    required this.width,
    required this.height,
    required this.imageUrl,
    required this.borderRadius,
    this.alignment = Alignment.center,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
      
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        placeholder: (context, url) => ShimmerBox(
          height: height,
          width: width,
          borderRadius: borderRadius,
        ),
        errorBuilder: (context, url, error) => ShimmerBox(
          height: height,
          width: width,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}