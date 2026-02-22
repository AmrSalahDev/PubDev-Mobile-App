import 'package:pub_api_client/pub_api_client.dart';

abstract class SearchEvent {}

class PerformSearch extends SearchEvent {
  final String query;
  final SearchOrder sort;
  final bool reset;

  PerformSearch({
    this.query = '',
    this.sort = SearchOrder.top,
    this.reset = true,
  });
}

class LoadMoreResults extends SearchEvent {}
