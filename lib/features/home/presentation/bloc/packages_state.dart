import 'package:equatable/equatable.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';

class PackagesState extends Equatable {
  final List<PackageEntity> favorites;
  final List<PackageEntity> trending;
  final List<PackageEntity> topFlutter;
  final List<PackageEntity> topDart;
  final PackageEntity? packageInfo;
  final bool hasError;
  final String errorMessage;
  final bool isPackageInfoLoading;
  final bool isFavoritesLoading;
  final bool isTrendingLoading;
  final bool isTopFlutterLoading;
  final bool isTopDartLoading;

  const PackagesState({
    this.favorites = const [],
    this.trending = const [],
    this.topFlutter = const [],
    this.topDart = const [],
    this.hasError = false,
    this.errorMessage = '',
    this.isFavoritesLoading = false,
    this.isTrendingLoading = false,
    this.isTopFlutterLoading = false,
    this.isTopDartLoading = false,
    this.packageInfo,
    this.isPackageInfoLoading = false,
  });

  PackagesState copyWith({
    List<PackageEntity>? favorites,
    List<PackageEntity>? trending,
    List<PackageEntity>? topFlutter,
    List<PackageEntity>? topDart,
    bool? hasError,
    String? errorMessage,
    bool? isFavoritesLoading,
    bool? isTrendingLoading,
    bool? isTopFlutterLoading,
    bool? isTopDartLoading,
    PackageEntity? packageInfo,
    bool? isPackageInfoLoading,
  }) {
    return PackagesState(
      favorites: favorites ?? this.favorites,
      trending: trending ?? this.trending,
      topFlutter: topFlutter ?? this.topFlutter,
      topDart: topDart ?? this.topDart,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      isFavoritesLoading: isFavoritesLoading ?? this.isFavoritesLoading,
      isTrendingLoading: isTrendingLoading ?? this.isTrendingLoading,
      isTopFlutterLoading: isTopFlutterLoading ?? this.isTopFlutterLoading,
      isTopDartLoading: isTopDartLoading ?? this.isTopDartLoading,
      packageInfo: packageInfo ?? this.packageInfo,
      isPackageInfoLoading: isPackageInfoLoading ?? this.isPackageInfoLoading,
    );
  }

  @override
  List<Object?> get props => [
    favorites,
    trending,
    topFlutter,
    topDart,
    hasError,
    errorMessage,
    isFavoritesLoading,
    isTrendingLoading,
    isTopFlutterLoading,
    isTopDartLoading,
    packageInfo,
    isPackageInfoLoading,
  ];
}