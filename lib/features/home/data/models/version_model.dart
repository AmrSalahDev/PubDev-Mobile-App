import 'package:pub_dev_packages_app/features/home/domain/entities/version_entity.dart';

class VersionModel extends VersionEntity {
  const VersionModel({required super.version, required super.published});

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      version: json['version'] ?? '',
      // Use current time as a fallback to prevent app crashes
      published: DateTime.parse(
        json['published'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}