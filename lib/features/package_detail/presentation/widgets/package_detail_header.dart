import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/assets_gen/assets.gen.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';

class PackageDetailsHeader extends StatelessWidget {
  final PackageEntity packageInfo;
  const PackageDetailsHeader({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    final assets = Assets.svgs;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        assets.headerImageBg.svg(
          width: double.infinity,
          height: 0.45.sh,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              PackageInfoPart(packageInfo: packageInfo),
              24.verticalSpace,
              PackageStats(packageInfo: packageInfo),
            ],
          ),
        ),
      ],
    );
  }
}

class PackageStats extends StatelessWidget {
  final PackageEntity packageInfo;
  const PackageStats({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey),
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _scoreItem(packageInfo.score.likeCount.toString(), 'LIKES'),
          _vDivider(),
          _scoreItem(packageInfo.score.maxPoints.toString(), 'POINTS'),
          _vDivider(),
          _scoreItem(packageInfo.score.downloadCount30Days.toString(), 'DOWNLOADS'),
        ],
      ),
    );
  }

  Widget _scoreItem(String value, String label) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
    ],
  );

  Widget _vDivider() => Container(width: 1, height: 30, color: Colors.grey);
}

class PackageInfoPart extends StatelessWidget {
  final PackageEntity packageInfo;
  const PackageInfoPart({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${packageInfo.name} ${packageInfo.latest.version}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.grey, size: 20),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text: '${packageInfo.name}: ^${packageInfo.latest.version}',
                  ),
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Copied!')));
              },
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Published by
        Row(
          children: [
            Text(
              'Published ${_timeAgo(packageInfo.latest.published)} ',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            if (packageInfo.score.publisher != null)...[
            const Icon(Icons.verified, color: Colors.blue, size: 14),
            const SizedBox(width: 4),
             Text(
              packageInfo.score.publisher!,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
            ]
          ],
        ),
      ],
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
    return '${diff.inDays} days ago';
  }
}
