import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_package_info_usecase.dart';
import 'package:pub_dev_packages_app/features/search/domain/usecases/search_packages_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchPackagesUsecase searchPackagesUsecase;
  final GetPackageInfoUsecase getPackageInfoUsecase;

  SearchBloc(this.searchPackagesUsecase, this.getPackageInfoUsecase) : super(SearchInitial()) {
    on<PerformSearch>(_onPerformSearch);
    on<LoadMoreResults>(_onLoadMoreResults);
  }

  Future<void> _onPerformSearch(
    PerformSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final packageNames = await searchPackagesUsecase.call(
        query: event.query,
        page: 1,
        sort: event.sort,
      );

      final List<PackageEntity> packages = [];
      for (final name in packageNames) {
        final details = await getPackageInfoUsecase.call(name);
        packages.add(details);
      }

      emit(
        SearchLoaded(
          packages: packages,
          query: event.query,
          hasReachedMax: packages.length < 10, // Assuming 10 per page
          currentPage: 1,
          sort: event.sort,
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
      final packageNames = await searchPackagesUsecase.call(
        query: currentState.query,
        page: nextPage,
        sort: currentState.sort,
      );

      if (packageNames.isEmpty) {
        emit(currentState.copyWith(hasReachedMax: true));
        return;
      }

      final List<PackageEntity> newPackages = [];
      for (final name in packageNames) {
        final details = await getPackageInfoUsecase.call(name);
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
