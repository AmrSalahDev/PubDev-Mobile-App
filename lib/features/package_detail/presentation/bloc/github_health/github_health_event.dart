import 'package:equatable/equatable.dart';

abstract class GithubHealthEvent extends Equatable {
  const GithubHealthEvent();

  @override
  List<Object> get props => [];
}

class GetGithubHealthEvent extends GithubHealthEvent {
  final String repoUrl;

  const GetGithubHealthEvent(this.repoUrl);

  @override
  List<Object> get props => [repoUrl];
}
