import 'package:pub_dev_packages_app/features/home/data/models/pubspec_model.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/latest_entity.dart';

class LatestModel extends LatestEntity {
  const LatestModel({
    required super.version,
    required super.pubspec,
    required super.archiveUrl,
    required super.archiveSha256,
    required super.published,
  });

  factory LatestModel.fromJson(Map<String, dynamic> json) {
    return LatestModel(
      version: json['version'] ?? '',
      pubspec: PubspecModel.fromJson(json['pubspec'] ?? {}),
      archiveUrl: json['archive_url'] ?? '',
      archiveSha256: json['archive_sha256'] ?? '',
      // Use current time as a fallback to prevent app crashes
published: DateTime.parse(json['published'] ?? DateTime.now().toIso8601String()),
    );
  }
}
