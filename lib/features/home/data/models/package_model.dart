import 'package:pub_dev_packages_app/features/home/data/models/latest_model.dart';
import 'package:pub_dev_packages_app/features/home/data/models/score_model.dart';
import 'package:pub_dev_packages_app/features/home/data/models/version_model.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';

class PackageModel extends PackageEntity {
  const PackageModel({
    required super.name,
    required super.latest,
    required super.versions,
    required super.score,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
  return PackageModel(
    name: json['name'] ?? '',
    latest: LatestModel.fromJson(json['latest'] ?? {}),
    // Fix: json['versions'] is a List of objects, not a Map
    versions: (json['versions'] as List? ?? [])
        .map((v) => VersionModel.fromJson(v as Map<String, dynamic>))
        .toList(),
    score: ScoreModel.fromJson(json['score'] ?? {}),
  );
}
}
