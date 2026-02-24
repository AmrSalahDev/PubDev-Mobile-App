import 'package:pub_dev_packages_app/features/home/domain/entities/pubspec_entity.dart';

class PubspecModel extends PubspecEntity {
  const PubspecModel({
    required super.name,
    required super.description,
    required super.version,
    required super.homepage,
    required super.environment,
    required super.dependencies,
    required super.devDependencies,
    required super.topics,
  });

  factory PubspecModel.fromJson(Map<String, dynamic> json) {
  return PubspecModel(
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    version: json['version'] ?? '',
    homepage: json['homepage'] ?? '',
    environment: json['environment'] ?? {},
    dependencies: json['dependencies'] ?? {},
    devDependencies: json['dev_dependencies'] ?? {},
    // Fix: Convert the List<dynamic> to List<String> 
    // and use [] as default instead of {}
    topics: List<String>.from(json['topics'] ?? []), 
  );
}
}
