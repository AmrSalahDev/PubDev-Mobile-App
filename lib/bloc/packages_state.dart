import 'package:equatable/equatable.dart';
import '../core/api_client.dart';

abstract class PackagesState extends Equatable {
  const PackagesState();

  @override
  List<Object?> get props => [];
}

class PackagesInitial extends PackagesState {}

class PackagesLoading extends PackagesState {}

class PackagesLoaded extends PackagesState {
  final List<PubDevPackage> favorites;
  final List<PubDevPackage> trending;
  final List<PubDevPackage> topFlutter;
  final List<PubDevPackage> topDart;
  final List<PubDevPackage> searchResults;
  final bool isSearching;
  final String searchQuery;

  const PackagesLoaded({
    required this.favorites,
    required this.trending,
    required this.topFlutter,
    required this.topDart,
    this.searchResults = const [],
    this.isSearching = false,
    this.searchQuery = '',
  });

  PackagesLoaded copyWith({
    List<PubDevPackage>? favorites,
    List<PubDevPackage>? trending,
    List<PubDevPackage>? topFlutter,
    List<PubDevPackage>? topDart,
    List<PubDevPackage>? searchResults,
    bool? isSearching,
    String? searchQuery,
  }) {
    return PackagesLoaded(
      favorites: favorites ?? this.favorites,
      trending: trending ?? this.trending,
      topFlutter: topFlutter ?? this.topFlutter,
      topDart: topDart ?? this.topDart,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    favorites,
    trending,
    topFlutter,
    topDart,
    searchResults,
    isSearching,
    searchQuery,
  ];
}

class PackagesError extends PackagesState {
  final String message;

  const PackagesError({required this.message});

  @override
  List<Object?> get props => [message];
}
