import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/network/network_config.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/http_service.dart';
import '../../core/services/search_history_service.dart';
import '../../core/services/image_upload_service.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/search_remote_data_source.dart';
import '../../data/datasources/cart_remote_data_source.dart';
import '../../data/datasources/shop_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/shop_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/shop_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/otp_usecases.dart';
import '../../domain/usecases/get_category_detail_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart' as search;
import '../../domain/usecases/search_products_advanced_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/get_product_detail_usecase.dart';
import '../../domain/usecases/get_product_images_usecase.dart';
import '../../domain/usecases/get_product_primary_images_usecase.dart';
import '../../domain/usecases/get_flash_sales.dart';
import '../../domain/usecases/get_flash_sale_products.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/remove_cart_item_usecase.dart';
import '../../domain/usecases/remove_multiple_cart_items_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_preview_usecase.dart';
import '../../domain/usecases/get_preview_order_usecase.dart';
import '../../domain/usecases/get_shops_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_as_read_usecase.dart';
import '../../domain/usecases/get_unread_notification_count_usecase.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/datasources/flash_sale_remote_data_source.dart';
import '../../data/datasources/flash_sale_remote_data_source_impl.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../data/repositories/flash_sale_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/repositories/flash_sale_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/home/home_bloc.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/blocs/product_detail/product_detail_bloc.dart';
import '../../presentation/blocs/search/search_bloc.dart';
import '../../presentation/blocs/search/advanced_search_bloc.dart';
import '../../presentation/blocs/cart/cart_bloc.dart';
import '../../presentation/blocs/category_detail/category_detail_bloc.dart';
import '../../presentation/blocs/notification/notification_bloc.dart';
import '../../presentation/blocs/shop/shop_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<FlutterSecureStorage>(() {
    try {
      return const FlutterSecureStorage();
    } catch (e) {
      
      rethrow;
    }  });
  
  getIt.registerLazySingleton<StorageService>(() => StorageService(getIt()));
  
  HttpService.initialize(storageService: getIt<StorageService>());
  
  getIt.registerLazySingleton<Dio>(() => NetworkConfig.createDio(storageService: getIt()));
  
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () {
      FlutterSecureStorage? secureStorage;
      try {
        secureStorage = getIt<FlutterSecureStorage>();      } catch (e) {
        
        secureStorage = null;
      }      return AuthLocalDataSourceImpl(secureStorage);
    },
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
    
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt()));
    getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => ResendOtpUseCase(getIt()));
  
  // Home dependencies
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => GetCategoriesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCategoryDetailUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductsByCategoryUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductsUseCase(getIt()));
  getIt.registerLazySingleton(() => search.SearchProductsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductDetailUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductImagesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductPrimaryImagesUseCase(getIt()));
  
  // Advanced Search dependencies
  getIt.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(getIt()),
  );
  
  getIt.registerLazySingleton(() => SearchProductsAdvancedUseCase(getIt()));
  
  // Flash Sale dependencies
  getIt.registerLazySingleton<FlashSaleRemoteDataSource>(
    () => FlashSaleRemoteDataSourceImpl(dio: getIt()),
  );
  
  getIt.registerLazySingleton<FlashSaleRepository>(
    () => FlashSaleRepositoryImpl(remoteDataSource: getIt()),
  );
  
  getIt.registerLazySingleton(() => GetFlashSalesUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetFlashSaleProductsUseCase(repository: getIt()));
  
  // Search service
  getIt.registerLazySingleton(() => SearchHistoryService());
  
  // Image upload service
  getIt.registerLazySingleton(() => ImageUploadService(getIt()));
  
  // Profile dependencies
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );
  
  getIt.registerLazySingleton(() => GetUserProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserProfileUseCase(getIt()));
  
  // Cart dependencies
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(getIt()),
  );
  
  getIt.registerLazySingleton(() => AddToCartUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCartItemsUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateCartItemUseCase(getIt()));
  getIt.registerLazySingleton(() => RemoveFromCartUseCase(getIt()));
  getIt.registerLazySingleton(() => RemoveCartItemUseCase(getIt()));
  getIt.registerLazySingleton(() => RemoveMultipleCartItemsUseCase(getIt()));
  getIt.registerLazySingleton(() => ClearCartUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCartPreviewUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPreviewOrderUseCase(getIt()));
  
  // SHOP DEPENDENCIES
  getIt.registerLazySingleton<ShopRemoteDataSource>(
    () => ShopRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<ShopRepository>(
    () => ShopRepositoryImpl(remoteDataSource: getIt()),
  );
  
  getIt.registerLazySingleton(() => GetShopsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetShopByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductsByShopUseCase(getIt()));
  
  getIt.registerFactory(() => AuthBloc(
    loginUseCase: getIt(),
    registerUseCase: getIt(),
    verifyOtpUseCase: getIt(),
    resendOtpUseCase: getIt(),
    authRepository: getIt(),
  ));
  
  getIt.registerFactory(() => HomeBloc(
    getCategoriesUseCase: getIt(),
    getProductsUseCase: getIt(),
    getProductPrimaryImagesUseCase: getIt(),
    getFlashSalesUseCase: getIt(),
    getFlashSaleProductsUseCase: getIt(),
  ));
  
  getIt.registerFactory(() => SearchBloc(
    searchProductsUseCase: getIt(),
    getCategoriesUseCase: getIt(),
    getProductPrimaryImagesUseCase: getIt(),
    searchHistoryService: getIt(),
  ));
  
  getIt.registerFactory(() => AdvancedSearchBloc(
    searchProductsAdvancedUseCase: getIt(),
  ));
  
  getIt.registerFactory(() => ProfileBloc(
    getUserProfileUseCase: getIt(),
    updateUserProfileUseCase: getIt(),
  ));
  
  getIt.registerFactory(() => ProductDetailBloc(
    getProductDetailUseCase: getIt(),
    getProductImagesUseCase: getIt(),
    addToCartUseCase: getIt(),
    cartBloc: getIt(),
  ));

  getIt.registerFactory(() => CategoryDetailBloc(
    getCategoryDetailUseCase: getIt(),
    getProductsByCategoryUseCase: getIt(),
    getProductPrimaryImagesUseCase: getIt(),
  ));
  
  // Register CartBloc as singleton so all parts of the app share the same instance
  getIt.registerLazySingleton(() {
    print('Creating CartBloc singleton in DI');
    final cartBloc = CartBloc(
      addToCartUseCase: getIt(),
      getCartItemsUseCase: getIt(),
      updateCartItemUseCase: getIt(),
      removeFromCartUseCase: getIt(),
      removeCartItemUseCase: getIt(),
      removeMultipleCartItemsUseCase: getIt(),
      clearCartUseCase: getIt(),
      getCartPreviewUseCase: getIt(),
      getPreviewOrderUseCase: getIt(),
    );
    print('CartBloc singleton created: ${cartBloc.hashCode}');
    return cartBloc;
  });

  // === NOTIFICATION DEPENDENCIES ===
  // Data sources
  getIt.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetNotificationsUseCase(getIt()));
  getIt.registerLazySingleton(() => MarkNotificationAsReadUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUnreadNotificationCountUseCase(getIt()));

  // Blocs
  getIt.registerFactory(() => NotificationBloc(
    getNotificationsUseCase: getIt(),
    markNotificationAsReadUseCase: getIt(),
    getUnreadNotificationCountUseCase: getIt(),
  ));

  // === SHOP DEPENDENCIES ===
  // Register ShopBloc
  getIt.registerFactory(() => ShopBloc(
    getShopsUseCase: getIt(),
    getShopByIdUseCase: getIt(),
    getProductsByShopUseCase: getIt(),
  ));
}
