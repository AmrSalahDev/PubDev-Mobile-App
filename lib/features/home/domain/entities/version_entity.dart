import 'package:equatable/equatable.dart';

class VersionEntity extends Equatable {
  final String version;
  final DateTime published;

  const VersionEntity({
    required this.version,
    required this.published,
  });
  
  @override
  List<Object?> get props => [
    version,
    published,
  ];
}