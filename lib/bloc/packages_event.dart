import 'package:equatable/equatable.dart';

abstract class PackagesEvent extends Equatable {
  const PackagesEvent();

  @override
  List<Object> get props => [];
}

class LoadPackages extends PackagesEvent {}

class RefreshPackages extends PackagesEvent {}

class SearchPackages extends PackagesEvent {
  final String query;
  const SearchPackages(this.query);

  @override
  List<Object> get props => [query];
}
