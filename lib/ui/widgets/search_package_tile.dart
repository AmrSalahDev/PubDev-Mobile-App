import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../package_detail_page.dart';

class SearchPackageTile extends StatelessWidget {
  final PubDevPackage package;

  const SearchPackageTile({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackageDetailPage(package: package),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF263545))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    package.name,
                    style: const TextStyle(
                      color: Color(0xFF4EAFF7),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _scoreItem(package.likes.toString(), 'LIKES'),
                _scoreDivider(),
                _scoreItem(package.points.toString(), 'POINTS'),
                _scoreDivider(),
                _scoreItem(
                  '--',
                  'DOWNLOADS',
                ), // Download data not always available in main API
              ],
            ),
            const SizedBox(height: 12),
            Text(
              package.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFB0BEC5),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'v ${package.latestVersion}',
                  style: const TextStyle(
                    color: Color(0xFF4EAFF7),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '(${_timeAgo(package.published)})',
                  style: const TextStyle(
                    color: Color(0xFFB0BEC5),
                    fontSize: 12,
                  ),
                ),
                if (package.publisher.isNotEmpty) ...[
                  const Icon(
                    Icons.verified,
                    size: 14,
                    color: Color(0xFF4EAFF7),
                  ),
                  Text(
                    package.publisher,
                    style: const TextStyle(
                      color: Color(0xFF4EAFF7),
                      fontSize: 12,
                    ),
                  ),
                ],
                const Text(
                  'MIT',
                  style: TextStyle(color: Color(0xFFB0BEC5), fontSize: 12),
                ), // Default license for now
              ],
            ),
            const SizedBox(height: 12),
            _tagRow(),
          ],
        ),
      ),
    );
  }

  Widget _scoreItem(String value, String label) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Color(0xFF4EAFF7),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 9),
      ),
    ],
  );

  Widget _scoreDivider() => Container(
    height: 24,
    width: 1,
    color: const Color(0xFF263545),
    margin: const EdgeInsets.symmetric(horizontal: 12),
  );

  Widget _tagRow() => Wrap(
    spacing: 6,
    runSpacing: 6,
    children: [
      _tag('SDK', ['FLUTTER']),
      _tag('PLATFORM', ['ANDROID', 'IOS', 'LINUX', 'MACOS', 'WEB', 'WINDOWS']),
    ],
  );

  Widget _tag(String label, List<String> values) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFF1C2834),
      borderRadius: BorderRadius.circular(2),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          color: const Color(0xFF12202C),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFB0BEC5),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        for (final v in values)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text(
              v,
              style: const TextStyle(
                color: Color(0xFF4EAFF7),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    ),
  );

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()} years ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    return 'just now';
  }
}
