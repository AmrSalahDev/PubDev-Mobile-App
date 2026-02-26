import 'package:injectable/injectable.dart';
import 'package:pub_api_client/pub_api_client.dart';

abstract class SearchRemoteDataSource {
  Future<List<String>> searchPackages({
    required String query,
    required int page,
    required SearchOrder sort,
  });
}

@LazySingleton(as: SearchRemoteDataSource)
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final PubClient pubClient;

  SearchRemoteDataSourceImpl(this.pubClient);

  @override
  Future<List<String>> searchPackages({
    required String query,
    required int page,
    required SearchOrder sort,
  }) async {
    final result = await pubClient.search(query, page: page, sort: sort);
    return result.packages.map((p) => p.package).toList();
  }
}
