import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/livestream_entity.dart';
import '../../../domain/entities/user_profile_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  final List<LiveStreamEntity> liveStreams;
  final UserProfileEntity? userProfile;
  final bool hasMoreProducts;
  final bool isLoadingMore;

  const HomeLoaded({
    required this.categories,
    required this.products,
    required this.liveStreams,
    this.userProfile,
    this.hasMoreProducts = true,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
        categories,
        products,
        liveStreams,
        userProfile,
        hasMoreProducts,
        isLoadingMore,
      ];

  HomeLoaded copyWith({
    List<CategoryEntity>? categories,
    List<ProductEntity>? products,
    List<LiveStreamEntity>? liveStreams,
    UserProfileEntity? userProfile,
    bool? hasMoreProducts,
    bool? isLoadingMore,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      liveStreams: liveStreams ?? this.liveStreams,
      userProfile: userProfile ?? this.userProfile,
      hasMoreProducts: hasMoreProducts ?? this.hasMoreProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductSearchLoaded extends HomeState {
  final List<ProductEntity> searchResults;
  final String query;

  const ProductSearchLoaded({
    required this.searchResults,
    required this.query,
  });

  @override
  List<Object?> get props => [searchResults, query];
}

class UserProfileLoaded extends HomeState {
  final UserProfileEntity userProfile;

  const UserProfileLoaded(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class UserProfileError extends HomeState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
