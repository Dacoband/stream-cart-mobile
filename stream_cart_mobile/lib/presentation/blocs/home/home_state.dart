import 'package:equatable/equatable.dart';
import '../../../domain/entities/products/product_entity.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/entities/livestream/livestream_entity.dart';
import '../../../domain/entities/account/user_profile_entity.dart';
import '../../../domain/entities/flash-sale/flash_sale_entity.dart';

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
  final List<FlashSaleEntity> flashSales;
  final List<ProductEntity> flashSaleProducts;
  final UserProfileEntity? userProfile;
  final bool hasMoreProducts;
  final bool isLoadingMore;
  final bool isLoadingFlashSales;
  final Map<String, String> productImages; // productId -> imageUrl

  const HomeLoaded({
    required this.categories,
    required this.products,
    required this.liveStreams,
    this.flashSales = const [],
    this.flashSaleProducts = const [],
    this.userProfile,
    this.hasMoreProducts = true,
    this.isLoadingMore = false,
    this.isLoadingFlashSales = false,
    this.productImages = const {},
  });

  @override
  List<Object?> get props => [
        categories,
        products,
        liveStreams,
        flashSales,
        flashSaleProducts,
        userProfile,
        hasMoreProducts,
        isLoadingMore,
        isLoadingFlashSales,
        productImages,
      ];

  HomeLoaded copyWith({
    List<CategoryEntity>? categories,
    List<ProductEntity>? products,
    List<LiveStreamEntity>? liveStreams,
    List<FlashSaleEntity>? flashSales,
    List<ProductEntity>? flashSaleProducts,
    UserProfileEntity? userProfile,
    bool? hasMoreProducts,
    bool? isLoadingMore,
    bool? isLoadingFlashSales,
    Map<String, String>? productImages,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      liveStreams: liveStreams ?? this.liveStreams,
      flashSales: flashSales ?? this.flashSales,
      flashSaleProducts: flashSaleProducts ?? this.flashSaleProducts,
      userProfile: userProfile ?? this.userProfile,
      hasMoreProducts: hasMoreProducts ?? this.hasMoreProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadingFlashSales: isLoadingFlashSales ?? this.isLoadingFlashSales,
      productImages: productImages ?? this.productImages,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
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
