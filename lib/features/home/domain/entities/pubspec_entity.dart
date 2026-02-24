import 'package:equatable/equatable.dart';

class PubspecEntity extends Equatable {
  final String name;
  final String description;
  final String version;
  final String homepage;
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
  ];
} 