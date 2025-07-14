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

class LoadMoreProductsEvent extends HomeEvent {
  const LoadMoreProductsEvent();
}

class LoadProductImagesEvent extends HomeEvent {
  final List<String> productIds;

  const LoadProductImagesEvent(this.productIds);

  @override
  List<Object?> get props => [productIds];
}

class LoadUserProfileEvent extends HomeEvent {
  const LoadUserProfileEvent();
}
