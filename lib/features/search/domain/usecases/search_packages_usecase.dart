import 'package:injectable/injectable.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_dev_packages_app/features/search/domain/repos/search_repo.dart';

@lazySingleton
class SearchPackagesUsecase {
  final SearchRepo searchRepo;

  SearchPackagesUsecase(this.searchRepo);

  Future<List<String>> call({
    required String query,
    required int page,
    required SearchOrder sort,
  }) async {
    return await searchRepo.searchPackages(query: query, page: page, sort: sort);
  }
}
