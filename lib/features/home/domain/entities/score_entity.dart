import 'package:equatable/equatable.dart';

class ScoreEntity extends Equatable {
  final int grantedPoints;
  final int maxPoints;
  final int likeCount;
  final int downloadCount30Days;
  final List<String> tags;
  final String? publisher;
  final List<String>? platforms;
  final List<String>? sdks;
  final List<String>? licenses;

  const ScoreEntity({
    required this.grantedPoints,
    required this.maxPoints,
    required this.likeCount,
    required this.downloadCount30Days,
    required this.tags,
    this.publisher,
    this.platforms,
    this.sdks,
    this.licenses,
  });

  @override
  List<Object?> get props => [
    grantedPoints,
    maxPoints,
    likeCount,
    downloadCount30Days,
    tags,
    publisher,
    platforms,
    sdks,
    licenses,
  ];
}
