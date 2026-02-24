import 'package:equatable/equatable.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/latest_entity.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/score_entity.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/version_entity.dart';

class PackageEntity extends Equatable {
  final String name;
  final LatestEntity latest;
  final ScoreEntity score;
  final List<VersionEntity> versions;

  const PackageEntity({
    required this.name,
    required this.latest,
    required this.score,
    required this.versions,
  });

  @override
  List<Object?> get props => [
    name,
    latest,
    score,
    versions,
  ];
 
}