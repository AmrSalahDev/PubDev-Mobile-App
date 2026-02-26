import 'package:pub_api_client/pub_api_client.dart';

abstract class SearchRepo {
  Future<List<String>> searchPackages({
    required String query,
    required int page,
    required SearchOrder sort,
  });
}
