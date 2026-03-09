import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/features/package_detail/data/datasets/remote/github_health_remote_data_source.dart';
import 'package:pub_dev_packages_app/features/package_detail/domain/entities/github_health_entity.dart';
import 'package:pub_dev_packages_app/features/package_detail/domain/repos/github_health_repository.dart';

@LazySingleton(as: GithubHealthRepository)
class GithubHealthRepositoryImpl implements GithubHealthRepository {
  final GithubHealthRemoteDataSource _remoteDataSource;

  GithubHealthRepositoryImpl(this._remoteDataSource);

  @override
  Future<GithubHealthEntity> getGithubHealth(String repoUrl) {
    return _remoteDataSource.getGithubHealth(repoUrl);
  }
}
