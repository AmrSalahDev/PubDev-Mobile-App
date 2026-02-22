import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pub_api_client/pub_api_client.dart';
import '../core/api_client.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PubDevApiClient apiClient;

  SearchBloc(this.apiClient) : super(SearchInitial()) {
    on<PerformSearch>(_onPerformSearch);
    on<LoadMoreResults>(_onLoadMoreResults);
  }

  Future<void> _onPerformSearch(
    PerformSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final packageNames = await apiClient.searchPackages(
        event.query,
        page: 1,
        sort: event.sort,
      );

      final List<PubDevPackage> packages = [];
      for (final name in packageNames) {
        final details = await apiClient.getPackageDetails(name);
        packages.add(details);
      }

      emit(
        SearchLoaded(
          packages: packages,
          query: event.query,
          hasReachedMax: packages.length < 10, // Assuming 10 per page
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onLoadMoreResults(
    LoadMoreResults event,
    Emitter<SearchState> emit,
  ) async {
    if (state is! SearchLoaded) return;
    final currentState = state as SearchLoaded;
    if (currentState.hasReachedMax) return;

    try {
      final nextPage = currentState.currentPage + 1;
      final packageNames = await apiClient.searchPackages(
        currentState.query,
        page: nextPage,
      );

      if (packageNames.isEmpty) {
        emit(currentState.copyWith(hasReachedMax: true));
        return;
      }

      final List<PubDevPackage> newPackages = [];
      for (final name in packageNames) {
        final details = await apiClient.getPackageDetails(name);
        newPackages.add(details);
      }

      emit(
        SearchLoaded(
          packages: List.from(currentState.packages)..addAll(newPackages),
          query: currentState.query,
          hasReachedMax: newPackages.length < 10,
          currentPage: nextPage,
        ),
      );
    } catch (e) {
      // Keep existing state but maybe show error snackbar elsewhere
    }
  }
}
