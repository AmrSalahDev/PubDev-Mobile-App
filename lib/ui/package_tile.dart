import 'package:flutter/material.dart';
import '../core/api_client.dart';
import 'package_detail_page.dart';

const _kCardBg = Color(0xFF1C2834);
const _kBlue = Color(0xFF5BB4F8);
const _kTextGrey = Color(0xFFB0BEC5);

class PackageTile extends StatelessWidget {
  final PubDevPackage package;

  const PackageTile({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PackageDetailPage(package: package),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: _kCardBg,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                package.name,
                style: const TextStyle(
                  color: _kBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  package.description,
                  style: const TextStyle(color: _kTextGrey, fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (package.publisher.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.verified, color: _kBlue, size: 12),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        package.publisher,
                        style: const TextStyle(color: _kBlue, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
