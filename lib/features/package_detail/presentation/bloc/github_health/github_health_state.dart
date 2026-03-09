import 'package:equatable/equatable.dart';
import 'package:pub_dev_packages_app/features/package_detail/domain/entities/github_health_entity.dart';

abstract class GithubHealthState extends Equatable {
  const GithubHealthState();

  @override
  List<Object?> get props => [];
}

class GithubHealthInitial extends GithubHealthState {}

class GithubHealthLoading extends GithubHealthState {}

class GithubHealthLoaded extends GithubHealthState {
  final GithubHealthEntity githubHealthEntity;

  const GithubHealthLoaded(this.githubHealthEntity);

  @override
  List<Object> get props => [githubHealthEntity];
}

class GithubHealthError extends GithubHealthState {
  final String message;

  const GithubHealthError(this.message);

  @override
  List<Object> get props => [message];
}
