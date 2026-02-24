import 'package:equatable/equatable.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/pubspec_entity.dart';

class LatestEntity extends Equatable {
   final String version;
  final PubspecEntity pubspec;
  final String archiveUrl;
  final String archiveSha256;
  final DateTime published;
  
  const LatestEntity({
    required this.version,
    required this.pubspec,
    required this.archiveUrl,
    required this.archiveSha256,
    required this.published,
  });
  
  @override
  List<Object?> get props => [
    version,
    pubspec,
    archiveUrl,
    archiveSha256,
    published,
  ];
}