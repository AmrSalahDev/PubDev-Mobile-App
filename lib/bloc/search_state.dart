import '../core/api_client.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<PubDevPackage> packages;
  final String query;
  final bool hasReachedMax;
  final int currentPage;

  SearchLoaded({
    required this.packages,
    required this.query,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  SearchLoaded copyWith({
    List<PubDevPackage>? packages,
    String? query,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return SearchLoaded(
      packages: packages ?? this.packages,
      query: query ?? this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
