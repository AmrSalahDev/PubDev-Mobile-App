import 'package:equatable/equatable.dart';
import '../../../../core/api_client.dart';

class PackagesState extends Equatable {
  final List<PubDevPackage> favorites;
  final List<PubDevPackage> trending;
  final List<PubDevPackage> topFlutter;
  final List<PubDevPackage> topDart;
  final bool hasError;
  final String errorMessage;
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
  });

  PackagesState copyWith({
    List<PubDevPackage>? favorites,
    List<PubDevPackage>? trending,
    List<PubDevPackage>? topFlutter,
    List<PubDevPackage>? topDart,
    bool? hasError,
    String? errorMessage,
    bool? isFavoritesLoading,
    bool? isTrendingLoading,
    bool? isTopFlutterLoading,
    bool? isTopDartLoading,
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
  ];
}