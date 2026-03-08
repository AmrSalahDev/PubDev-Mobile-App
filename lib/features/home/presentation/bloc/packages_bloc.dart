import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_favorites_packages_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_observable_videos_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_package_info_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_package_suggestions_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_top_dart_packages_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_top_flutter_packages_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_trending_packages_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_package_of_the_week_videos_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_widget_of_the_week_usecase.dart';
import 'package:pub_dev_packages_app/features/home/domain/usecases/search_videos_usecase.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_event.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_state.dart';

@injectable
class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  final GetFavoritesPackagesUsecase getFavoritesPackagesUsecase;
  final GetTrendingPackagesUsecase getTrendingPackagesUsecase;
  final GetTopFlutterPackagesUsecase getTopFlutterPackagesUsecase;
  final GetTopDartPackagesUsecase getTopDartPackagesUsecase;
  final GetPackageInfoUsecase getPackageInfoUsecase;
  final GetPackageOfTheWeekVideosUsecase getPackageOfTheWeekVideosUsecase;
  final GetObservableVideosUsecase getObservableVideosUsecase;
  final GetWidgetOfTheWeekVideosUsecase getWidgetOfTheWeekVideosUsecase;
  final GetPackageSuggestionsUseCase getPackageSuggestionsUseCase;
  final SearchVideosUsecase searchVideosUsecase;

  PackagesBloc({
    required this.getFavoritesPackagesUsecase,
    required this.getTrendingPackagesUsecase,
    required this.getTopFlutterPackagesUsecase,
    required this.getTopDartPackagesUsecase,
    required this.getPackageInfoUsecase,
    required this.getPackageOfTheWeekVideosUsecase,
    required this.getObservableVideosUsecase,
    required this.getWidgetOfTheWeekVideosUsecase,
    required this.getPackageSuggestionsUseCase,
    required this.searchVideosUsecase,
  }) : super(const PackagesState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<LoadTrendingEvent>(_onLoadTrending);
    on<LoadTopFlutterEvent>(_onLoadTopFlutter);
    on<LoadTopDartEvent>(_onLoadTopDart);
    on<RefreshPackagesEvent>(_onRefreshPackages);
    on<LoadPackageInfoEvent>(_onLoadPackageInfo);
    on<LoadPackageOfTheWeekVideosEvent>(_onLoadPackageOfTheWeekVideos);
    on<LoadObservableVideosEvent>(_onLoadObservableVideos);
    on<LoadWidgetOfTheWeekVideosEvent>(_onLoadWidgetOfTheWeekVideos);
    on<SearchPackageVideosEvent>(_onSearchPackageVideos);
  }

  Future<void> _onSearchPackageVideos(
    SearchPackageVideosEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(isPackageVideosLoading: true, packageVideos: []));
    try {
      final videos = await searchVideosUsecase.call(
        "Flutter ${event.packageName} tutorial",
      );
      emit(
        state.copyWith(packageVideos: videos, isPackageVideosLoading: false),
      );
    } catch (e) {
      emit(
        state.copyWith(
          hasError: true,
          errorMessage: e.toString(),
          isPackageVideosLoading: false,
        ),
      );
    }
  }

  Future<void> _onLoadWidgetOfTheWeekVideos(
    LoadWidgetOfTheWeekVideosEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(isWidgetOfTheWeekVideosLoading: true));
    try {
      final youtubeVideos = await getWidgetOfTheWeekVideosUsecase.call();
      emit(
        state.copyWith(
          widgetOfTheWeekVideos: youtubeVideos,
          isWidgetOfTheWeekVideosLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(hasError: true, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadObservableVideos(
    LoadObservableVideosEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(isObservableVideosLoading: true));
    try {
      final youtubeVideos = await getObservableVideosUsecase.call();
      emit(
        state.copyWith(
          observableVideos: youtubeVideos,
          isObservableVideosLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(hasError: true, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadPackageOfTheWeekVideos(
    LoadPackageOfTheWeekVideosEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(isPackageOfTheWeekVideosLoading: true));
    try {
      final youtubeVideos = await getPackageOfTheWeekVideosUsecase.call();
      emit(
        state.copyWith(
          packageOfTheWeekVideos: youtubeVideos,
          isPackageOfTheWeekVideosLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(hasError: true, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadPackageInfo(
    LoadPackageInfoEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(isPackageInfoLoading: true));
    try {
      final packageInfo = await getPackageInfoUsecase.call(event.packageName);
      emit(
        state.copyWith(packageInfo: packageInfo, isPackageInfoLoading: false),
      );
    } catch (e) {
      emit(state.copyWith(hasError: true, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(isFavoritesLoading: true));
    try {
      final favPackages = await getFavoritesPackagesUsecase.call(page: 1);
      final packageSuggestions = getPackageSuggestionsUseCase.call();
      emit(
        state.copyWith(
          favorites: favPackages,
          isFavoritesLoading: false,
          packageSuggestions: packageSuggestions,
        ),
      );
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
}
