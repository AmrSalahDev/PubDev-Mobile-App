import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/features/package_detail/domain/entities/github_health_entity.dart';
import 'package:pub_dev_packages_app/features/package_detail/domain/repos/github_health_repository.dart';

@lazySingleton
class GetGithubHealthUsecase {
  final GithubHealthRepository _repository;

  GetGithubHealthUsecase(this._repository);

  Future<GithubHealthEntity> call(String repoUrl) {
    return _repository.getGithubHealth(repoUrl);
  }
}
