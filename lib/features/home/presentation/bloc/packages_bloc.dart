import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_favorites_packages_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_package_info_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_top_dart_packages_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_top_flutter_packages_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_trending_packages_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_youtube_package_videos_usecase.dart';
import 'packages_event.dart';
import 'packages_state.dart';

@injectable
class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  final GetFavoritesPackagesUsecase getFavoritesPackagesUsecase;
  final GetTrendingPackagesUsecase getTrendingPackagesUsecase;
  final GetTopFlutterPackagesUsecase getTopFlutterPackagesUsecase;
  final GetTopDartPackagesUsecase getTopDartPackagesUsecase;
  final GetPackageInfoUsecase getPackageInfoUsecase;
  final GetYoutubePackageVideosUsecase getYoutubeVideosUsecase;

  PackagesBloc({
    required this.getFavoritesPackagesUsecase,
    required this.getTrendingPackagesUsecase,
    required this.getTopFlutterPackagesUsecase,
    required this.getTopDartPackagesUsecase,
    required this.getPackageInfoUsecase,
    required this.getYoutubeVideosUsecase,
  }) : super(const PackagesState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<LoadTrendingEvent>(_onLoadTrending);
    on<LoadTopFlutterEvent>(_onLoadTopFlutter);
    on<LoadTopDartEvent>(_onLoadTopDart);
    on<RefreshPackagesEvent>(_onRefreshPackages);
    on<LoadPackageInfoEvent>(_onLoadPackageInfo);
    on<LoadYoutubeVideosEvent>(_onLoadYoutubeVideos);
  }

  Future<void> _onLoadYoutubeVideos(
    LoadYoutubeVideosEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(isYoutubeVideosLoading: true));
    try {
      final youtubeVideos = await getYoutubeVideosUsecase.call();
      emit(state.copyWith(youtubeVideos: youtubeVideos, isYoutubeVideosLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          hasError: true,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadPackageInfo(
    LoadPackageInfoEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(isPackageInfoLoading: true));
    try {
      final packageInfo = await getPackageInfoUsecase.call(event.packageName);
      emit(state.copyWith(packageInfo: packageInfo, isPackageInfoLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          hasError: true,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(isFavoritesLoading: true));
    try {
      final favPackages = await getFavoritesPackagesUsecase.call(page: 1);
      emit(state.copyWith(favorites: favPackages, isFavoritesLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          hasError: true,
          errorMessage: e.toString(),
          isFavoritesLoading: false,
        ),
      );
    }
  }

  Future<void> _onLoadTrending(
    LoadTrendingEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(isTrendingLoading: true));
    try {
      final trendingPackages = await getTrendingPackagesUsecase.call(page: 1);
      
      emit(
        state.copyWith(trending: trendingPackages, isTrendingLoading: false),
      );
    } catch (e) {
      emit(
        state.copyWith(
          hasError: true,
          errorMessage: e.toString(),
          isTrendingLoading: false,
        ),
      );
    }
  }

  Future<void> _onLoadTopFlutter(
    LoadTopFlutterEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(isTopFlutterLoading: true));
    try {
      final topFlutterPackages = await getTopFlutterPackagesUsecase.call(
        page: 1,
      );
      
      emit(
        state.copyWith(
          topFlutter: topFlutterPackages,
          isTopFlutterLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          hasError: true,
          errorMessage: e.toString(),
          isTopFlutterLoading: false,
        ),
      );
    }
  }

  Future<void> _onLoadTopDart(
    LoadTopDartEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(isTopDartLoading: true));
    try {
      final topDartPackages = await getTopDartPackagesUsecase.call(page: 1);
      
      emit(state.copyWith(topDart: topDartPackages, isTopDartLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          hasError: true,
          errorMessage: e.toString(),
          isTopDartLoading: false,
        ),
      );
    }
  }

  Future<void> _onRefreshPackages(
    RefreshPackagesEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(
      state.copyWith(
        isFavoritesLoading: true,
        isTrendingLoading: true,
        isTopFlutterLoading: true,
        isTopDartLoading: true,
      ),
    );

    await Future.wait([
      _onLoadFavorites(LoadFavoritesEvent(), emit),
      _onLoadTrending(LoadTrendingEvent(), emit),
      _onLoadTopFlutter(LoadTopFlutterEvent(), emit),
      _onLoadTopDart(LoadTopDartEvent(), emit),
    ]);
  }

  // Future<void> _onLoadPackages(
  //   LoadPackages event,
  //   Emitter<PackagesState> emit,
  // ) async {
  //   if (state is PackagesInitial) {
  //     emit(PackagesLoading());
  //     await _fetchAllSections(emit);
  //   }
  // }

  // Future<void> _onRefreshPackages(
  //   RefreshPackages event,
  //   Emitter<PackagesState> emit,
  // ) async {
  //   emit(PackagesLoading());
  //   await _fetchAllSections(emit);
  // }

  // Future<void> _onSearchPackages(
  //   SearchPackages event,
  //   Emitter<PackagesState> emit,
  // ) async {
  //   if (state is! PackagesLoaded) return;
  //   final current = state as PackagesLoaded;

  //   if (event.query.trim().isEmpty) {
  //     emit(
  //       current.copyWith(
  //         isSearching: false,
  //         searchResults: [],
  //         searchQuery: '',
  //       ),
  //     );
  //     return;
  //   }

  //   emit(current.copyWith(isSearching: true, searchQuery: event.query));

  //   try {
  //     final names = await apiClient.searchPackages(event.query);
  //     final pkgs = await _fetchDetails(names.take(20).toList());
  //     emit(current.copyWith(searchResults: pkgs, searchQuery: event.query));
  //   } catch (e) {
  //     // keep showing old results on error
  //   }
  // }

  // Future<void> _fetchAllSections(Emitter<PackagesState> emit) async {
  //   try {
  //     // Fetch all lists concurrently
  //     final results = await Future.wait([
  //       apiClient.getFlutterFavorites(),
  //       apiClient.getTrendingPackages(),
  //       apiClient.getTopFlutterPackages(),
  //       apiClient.getTopDartPackages(),
  //     ]);

  //     final favoriteNames = results[0].take(8).toList();
  //     final trendingNames = results[1].take(4).toList();
  //     final topFlutterNames = results[2].take(4).toList();
  //     final topDartNames = results[3].take(4).toList();

  //     // Fetch package details for all sections concurrently
  //     final detailResults = await Future.wait([
  //       _fetchDetails(favoriteNames),
  //       _fetchDetails(trendingNames),
  //       _fetchDetails(topFlutterNames),
  //       _fetchDetails(topDartNames),
  //     ]);

  //     emit(
  //       PackagesLoaded(
  //         favorites: detailResults[0],
  //         trending: detailResults[1],
  //         topFlutter: detailResults[2],
  //         topDart: detailResults[3],
  //       ),
  //     );
  //   } catch (e) {
  //     emit(PackagesError(message: e.toString()));
  //   }
  // }

  // Future<List<PubDevPackage>> _fetchDetails(List<String> names) async {
  //   final List<PubDevPackage> packages = [];
  //   for (final name in names) {
  //     try {
  //       final details = await apiClient.getPackageDetails(name);
  //       packages.add(details);
  //     } catch (e) {
  //       // ignore: avoid_print
  //       print('Failed to load details for $name: $e');
  //     }
  //   }
  //   return packages;
  // }
}
