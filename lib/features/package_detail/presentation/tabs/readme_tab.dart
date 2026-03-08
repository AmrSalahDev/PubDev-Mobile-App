import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadmeTab extends StatelessWidget {
  final PackageEntity packageInfo;

  const ReadmeTab({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    if (packageInfo.readme.isEmpty) {
      final repoUrl =
          packageInfo.latest.pubspec.repository ??
          packageInfo.latest.pubspec.homepage;

      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.description_outlined,
                size: 64.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: 16.h),
              Text(
                AppLocalizations.of(context).noReadmeFound,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                AppLocalizations.of(context).noReadmeProvided,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (repoUrl.isNotEmpty) ...[
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () => _launchUrl(repoUrl),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(AppLocalizations.of(context).visitRepository),
                ),
              ],
            ],
          ),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = isDark
        ? MarkdownConfig.darkConfig
        : MarkdownConfig.defaultConfig;

    return MarkdownWidget(
      data: packageInfo.readme,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      config: config.copy(
        configs: [
          LinkConfig(
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
            onTap: (url) => _launchUrl(url),
          ),
          PreConfig(
            theme: isDark ? a11yDarkTheme : a11yLightTheme,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.all(12.w),
          ),
          CodeConfig(
            style: TextStyle(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              fontFamily: 'monospace',
            ),
          ),
          TableConfig(
            headerStyle: const TextStyle(fontWeight: FontWeight.bold),
            wrapper: (child) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: child,
            ),
          ),
          _buildImgConfig(isDark),
        ],
      ),
    );
  }

  ImgConfig _buildImgConfig(bool isDark) {
    return ImgConfig(
      builder: (url, attributes) {
        final resolvedUrl = _resolveUrl(url);
        final widthStr = attributes['width'];
        final heightStr = attributes['height'];
        final width = widthStr != null ? double.tryParse(widthStr) : null;
        final height = heightStr != null ? double.tryParse(heightStr) : null;

        Widget imageWidget;

        // Handle SVG (badges)
        if (resolvedUrl.toLowerCase().contains('.svg') ||
            resolvedUrl.contains('img.shields.io') ||
            resolvedUrl.contains('badge.svg')) {
          imageWidget = SvgPicture.network(
            resolvedUrl,
            width: width,
            height: height,
            placeholderBuilder: (_) => const SizedBox(
              width: 20,
              height: 20,
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorBuilder: (_, _, _) => const Icon(Icons.broken_image, size: 20),
          );
        } else {
          // Handle normal images and GIFs
          // Use Image.network directly for better GIF support in some environments
          // as CachedNetworkImage sometimes has issues with specific GIF headers
          imageWidget = CachedNetworkImage(
            imageUrl: resolvedUrl,
            width: width,
            height: height,
            placeholder: (context, url) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Image.network(
              resolvedUrl,
              width: width,
              height: height,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
            ),
            fit: BoxFit.contain,
          );
        }

        return imageWidget;
      },
    );
  }

  String _resolveUrl(String url) {
    if (url.isEmpty) return url;
    if (url.startsWith('data:')) return url;

    String finalUrl = url;

    // 1. Handle Relative URLs
    if (!url.startsWith('http')) {
      if (packageInfo.readmeUrl != null && packageInfo.readmeUrl!.isNotEmpty) {
        // readmeUrl example: https://raw.githubusercontent.com/user/repo/main/README.md
        final baseUrl = packageInfo.readmeUrl!.replaceFirst('/README.md', '');

        if (url.startsWith('/')) {
          final uri = Uri.parse(baseUrl);
          final host = '${uri.scheme}://${uri.host}';
          finalUrl = '$host$url';
        } else {
          finalUrl = '$baseUrl/$url';
        }
      }
    }

    // 2. Normalize GitHub URLs
    // Convert github.com blob/raw URLs to the direct raw user content URL
    if (finalUrl.contains('github.com')) {
      // Replace github.com/user/repo/blob/main/img.gif with raw.githubusercontent.com/user/repo/main/img.gif
      if (finalUrl.contains('/blob/')) {
        finalUrl = finalUrl
            .replaceFirst('github.com', 'raw.githubusercontent.com')
            .replaceFirst('/blob/', '/');
      }
      // Handle github.com/user/repo/raw/main/img.gif
      else if (finalUrl.contains('/raw/')) {
        finalUrl = finalUrl
            .replaceFirst('github.com', 'raw.githubusercontent.com')
            .replaceFirst('/raw/', '/');
      }

      // Ensure it doesn't end with ?raw=true if we already converted to raw.githubusercontent
      if (finalUrl.contains('raw.githubusercontent.com') &&
          finalUrl.contains('?raw=true')) {
        finalUrl = finalUrl.split('?')[0];
      }
    }

    return finalUrl;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
