import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/api_client.dart';
import 'packages_event.dart';
import 'packages_state.dart';

class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  final PubDevApiClient apiClient;

  PackagesBloc({required this.apiClient}) : super(PackagesInitial()) {
    on<LoadPackages>(_onLoadPackages);
    on<RefreshPackages>(_onRefreshPackages);
    on<SearchPackages>(_onSearchPackages);
  }

  Future<void> _onLoadPackages(
    LoadPackages event,
    Emitter<PackagesState> emit,
  ) async {
    if (state is PackagesInitial) {
      emit(PackagesLoading());
      await _fetchAllSections(emit);
    }
  }

  Future<void> _onRefreshPackages(
    RefreshPackages event,
    Emitter<PackagesState> emit,
  ) async {
    emit(PackagesLoading());
    await _fetchAllSections(emit);
  }

  Future<void> _onSearchPackages(
    SearchPackages event,
    Emitter<PackagesState> emit,
  ) async {
    if (state is! PackagesLoaded) return;
    final current = state as PackagesLoaded;

    if (event.query.trim().isEmpty) {
      emit(
        current.copyWith(
          isSearching: false,
          searchResults: [],
          searchQuery: '',
        ),
      );
      return;
    }

    emit(current.copyWith(isSearching: true, searchQuery: event.query));

    try {
      final names = await apiClient.searchPackages(event.query);
      final pkgs = await _fetchDetails(names.take(20).toList());
      emit(current.copyWith(searchResults: pkgs, searchQuery: event.query));
    } catch (e) {
      // keep showing old results on error
    }
  }

  Future<void> _fetchAllSections(Emitter<PackagesState> emit) async {
    try {
      // Fetch all lists concurrently
      final results = await Future.wait([
        apiClient.getFlutterFavorites(),
        apiClient.getTrendingPackages(),
        apiClient.getTopFlutterPackages(),
        apiClient.getTopDartPackages(),
      ]);

      final favoriteNames = results[0].take(8).toList();
      final trendingNames = results[1].take(4).toList();
      final topFlutterNames = results[2].take(4).toList();
      final topDartNames = results[3].take(4).toList();

      // Fetch package details for all sections concurrently
      final detailResults = await Future.wait([
        _fetchDetails(favoriteNames),
        _fetchDetails(trendingNames),
        _fetchDetails(topFlutterNames),
        _fetchDetails(topDartNames),
      ]);

      emit(
        PackagesLoaded(
          favorites: detailResults[0],
          trending: detailResults[1],
          topFlutter: detailResults[2],
          topDart: detailResults[3],
        ),
      );
    } catch (e) {
      emit(PackagesError(message: e.toString()));
    }
  }

  Future<List<PubDevPackage>> _fetchDetails(List<String> names) async {
    final List<PubDevPackage> packages = [];
    for (final name in names) {
      try {
        final details = await apiClient.getPackageDetails(name);
        packages.add(details);
      } catch (e) {
        // ignore: avoid_print
        print('Failed to load details for $name: $e');
      }
    }
    return packages;
  }
}
