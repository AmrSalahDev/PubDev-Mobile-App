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
    required super.readme,
    super.readmeUrl,
  });

  factory PackageModel.fromJson(
    Map<String, dynamic> json, {
    String readme = '',
    String? readmeUrl,
  }) {
    return PackageModel(
      name: json['name'] ?? '',
      latest: LatestModel.fromJson(json['latest'] ?? {}),
      versions: (json['versions'] as List? ?? [])
          .map((v) => VersionModel.fromJson(v as Map<String, dynamic>))
          .toList(),
      score: ScoreModel.fromJson(json['score'] ?? {}),
      readme: readme,
      readmeUrl: readmeUrl,
    );
  }
}
