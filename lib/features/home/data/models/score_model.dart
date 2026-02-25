import 'package:pub_dev_packages_app/features/home/domain/entities/score_entity.dart';

class ScoreModel extends ScoreEntity {
  const ScoreModel({
    required super.grantedPoints,
    required super.maxPoints,
    required super.likeCount,
    required super.downloadCount30Days,
    required super.tags,
    super.publisher,
    super.platforms,
    super.sdks,
    super.licenses,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
     final tags = List<String>.from(json['tags'] ?? []);
     

    // Extract publisher
    final publisherTag = tags.firstWhere(
      (tag) => tag.startsWith('publisher:'),
      orElse: () => '',
    );

    final publisher = publisherTag.isNotEmpty
        ? publisherTag.split(':').last
        : null;

    // Extract platforms
    final platformTags = tags.where((tag) => tag.startsWith('platform:')).toList();
    final platforms = platformTags.map((tag) => tag.split(':').last).toList();

    // Extract SDKs
    final sdkTags = tags.where((tag) => tag.startsWith('sdk:')).toList();
    final sdks = sdkTags.map((tag) => tag.split(':').last).toList();    

    // Extract Licenses
    final licenseTags = tags.where((tag) => tag.startsWith('license:')).toList();
    final licenses = licenseTags.map((tag) => tag.split(':').last).toList();

    return ScoreModel(
      grantedPoints: json['grantedPoints'] ?? 0,
      maxPoints: json['maxPoints'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      downloadCount30Days: json['downloadCount30Days'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      publisher: publisher,
      platforms: platforms,
      sdks: sdks,
      licenses: licenses,
    );
  }
}
