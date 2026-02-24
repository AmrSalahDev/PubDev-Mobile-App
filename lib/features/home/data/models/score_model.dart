import 'package:pub_dev_packages_app/features/home/domain/entities/score_entity.dart';

class ScoreModel extends ScoreEntity {
  const ScoreModel({
    required super.grantedPoints,
    required super.maxPoints,
    required super.likeCount,
    required super.downloadCount30Days,
    required super.tags,
    super.publisher,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
     final tags = List<String>.from(json['tags'] ?? []);
     print(tags);

    // Extract publisher
    final publisherTag = tags.firstWhere(
      (tag) => tag.startsWith('publisher:'),
      orElse: () => '',
    );

    final publisher = publisherTag.isNotEmpty
        ? publisherTag.split(':').last
        : null;

    return ScoreModel(
      grantedPoints: json['grantedPoints'] ?? 0,
      maxPoints: json['maxPoints'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      downloadCount30Days: json['downloadCount30Days'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      publisher: publisher,
      
    );
  }
}
