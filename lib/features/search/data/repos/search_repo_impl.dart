import 'package:injectable/injectable.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_dev_packages_app/features/search/data/remote/search_remote_datasource.dart';
import 'package:pub_dev_packages_app/features/search/domain/repos/search_repo.dart';

@LazySingleton(as: SearchRepo)
class SearchRepoImpl implements SearchRepo {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepoImpl(this.remoteDataSource);

  @override
  Future<List<String>> searchPackages({
    required String query,
    required int page,
    required SearchOrder sort,
  }) {
    return remoteDataSource.searchPackages(
      query: query,
      page: page,
      sort: sort,
    );
  }
}
