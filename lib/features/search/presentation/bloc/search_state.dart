import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';


abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<PackageEntity> packages;
  final String query;
  final bool hasReachedMax;
  final int currentPage;
  final SearchOrder sort;

  SearchLoaded({
    required this.packages,
    required this.query,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.sort = SearchOrder.top,
    
  });

  SearchLoaded copyWith({
    List<PackageEntity>? packages,
    String? query,
    bool? hasReachedMax,
    int? currentPage,
    SearchOrder? sort,
  }) {
    return SearchLoaded(
      packages: packages ?? this.packages,
      query: query ?? this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      sort: sort ?? this.sort,
    );
  }
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
