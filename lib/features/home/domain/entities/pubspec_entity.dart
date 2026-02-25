import 'package:equatable/equatable.dart';

class PubspecEntity extends Equatable {
  final String name;
  final String description;
  final String version;
  final String homepage;
  final String? repository;
  final String? archiveUrl;
  final String? packageUrl;
  final String? issueTracker;
  final String? license;
  final List<String> topics;
  final Map<String, dynamic>? environment;
  final Map<String, dynamic>? dependencies;
  final Map<String, dynamic>? devDependencies;
  
  const PubspecEntity({
    required this.name,
    required this.description,
    required this.version,
    required this.homepage,
    required this.environment,
    required this.dependencies,
    required this.devDependencies,
    required this.topics,
    this.archiveUrl,
    this.packageUrl,
    this.repository,
    this.issueTracker,
    this.license,
  });
  
  @override
  List<Object?> get props => [
    name,
    description,
    version,
    homepage,
    environment,
    dependencies,
    devDependencies,
    topics,
    archiveUrl,
    packageUrl,
    repository,
    issueTracker,
    license,
  ];
} 