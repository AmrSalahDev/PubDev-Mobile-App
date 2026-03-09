import 'package:pub_dev_packages_app/features/package_detail/domain/entities/github_health_entity.dart';

abstract class GithubHealthRepository {
  Future<GithubHealthEntity> getGithubHealth(String repoUrl);
}
