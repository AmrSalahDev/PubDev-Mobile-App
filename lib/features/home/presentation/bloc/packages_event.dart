import 'package:equatable/equatable.dart';

abstract class PackagesEvent extends Equatable {
  const PackagesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesEvent extends PackagesEvent {}

class LoadTrendingEvent extends PackagesEvent {}

class LoadTopFlutterEvent extends PackagesEvent {}

class LoadTopDartEvent extends PackagesEvent {}

class RefreshPackagesEvent extends PackagesEvent {}

class LoadPackageInfoEvent extends PackagesEvent {
  final String packageName;

  const LoadPackageInfoEvent(this.packageName);
}

class LoadPackageOfTheWeekVideosEvent extends PackagesEvent {}

class LoadObservableVideosEvent extends PackagesEvent {}

class LoadWidgetOfTheWeekVideosEvent extends PackagesEvent {}

class SearchPackageVideosEvent extends PackagesEvent {
  final String packageName;

  const SearchPackageVideosEvent(this.packageName);

  @override
  List<Object> get props => [packageName];
}
