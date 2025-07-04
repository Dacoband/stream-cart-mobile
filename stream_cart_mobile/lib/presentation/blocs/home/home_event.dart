import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeDataEvent extends HomeEvent {
  const LoadHomeDataEvent();
}

class RefreshHomeDataEvent extends HomeEvent {
  const RefreshHomeDataEvent();
}

class SearchProductsEvent extends HomeEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreProductsEvent extends HomeEvent {
  const LoadMoreProductsEvent();
}

class LoadUserProfileEvent extends HomeEvent {
  const LoadUserProfileEvent();
}
