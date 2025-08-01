import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/network/network_config.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/http_service.dart';
import '../../core/services/search_history_service.dart';
import '../../core/services/image_upload_service.dart';
import '../../data/datasources/auth/auth_local_data_source.dart';
import '../../data/datasources/auth/auth_remote_data_source.dart';
import '../../data/datasources/search/search_remote_data_source.dart';
import '../../data/datasources/cart/cart_remote_data_source.dart';
import '../../data/datasources/shop/shop_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/shop_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/shop_repository.dart';
import '../../domain/usecases/chat/load_shop_chat_rooms_usecase.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/otp_usecases.dart';
import '../../domain/usecases/category/get_category_detail_usecase.dart';
import '../../domain/usecases/product/get_products_by_category_usecase.dart';
import '../../domain/usecases/category/get_categories_usecase.dart';
import '../../domain/usecases/product/get_products_usecase.dart';
import '../../domain/usecases/search/search_products_usecase.dart' as search;
import '../../domain/usecases/search/search_products_advanced_usecase.dart';
import '../../domain/usecases/account/get_user_profile_usecase.dart';
import '../../domain/usecases/account/update_user_profile.dart';
import '../../domain/usecases/product/get_product_detail_usecase.dart';
import '../../domain/usecases/product/get_product_images_usecase.dart';
import '../../domain/usecases/product/get_product_primary_images_usecase.dart';
import '../../domain/usecases/flash-sale/get_flash_sales.dart';
import '../../domain/usecases/flash-sale/get_flash_sale_products.dart';
import '../../domain/usecases/cart/add_to_cart_usecase.dart';
import '../../domain/usecases/cart/get_cart_items_usecase.dart';
import '../../domain/usecases/cart/update_cart_item_usecase.dart';
import '../../domain/usecases/cart/remove_from_cart_usecase.dart';
import '../../domain/usecases/cart/remove_cart_item_usecase.dart';
import '../../domain/usecases/cart/remove_multiple_cart_items_usecase.dart';
import '../../domain/usecases/cart/clear_cart_usecase.dart';
import '../../domain/usecases/cart/get_cart_preview_usecase.dart';
import '../../domain/usecases/order/get_preview_order_usecase.dart';
import '../../domain/usecases/shop/get_shops_usecase.dart';
import '../../domain/usecases/notification/get_notifications_usecase.dart';
import '../../domain/usecases/notification/mark_notification_as_read_usecase.dart';
import '../../domain/usecases/notification/get_unread_notification_count_usecase.dart';
import '../../data/datasources/home/home_remote_data_source.dart';
import '../../data/datasources/flash-sale/flash_sale_remote_data_source.dart';
import '../../data/datasources/flash-sale/flash_sale_remote_data_source_impl.dart';
import '../../data/datasources/notification/notification_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../data/repositories/flash_sale_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/repositories/flash_sale_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../data/datasources/account/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/chat/chat_event.dart';
import '../../presentation/blocs/home/home_bloc.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/blocs/product_detail/product_detail_bloc.dart';
import '../../presentation/blocs/search/search_bloc.dart';
import '../../presentation/blocs/search/advanced_search_bloc.dart';
import '../../presentation/blocs/cart/cart_bloc.dart';
import '../../presentation/blocs/category_detail/category_detail_bloc.dart';
import '../../presentation/blocs/notification/notification_bloc.dart';
import '../../presentation/blocs/shop/shop_bloc.dart';
import '../../data/datasources/chat/chat_remote_data_source.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/chat/load_chat_rooms_usecase.dart';
import '../../domain/usecases/chat/load_chat_room_by_shop_usecase.dart';
import '../../domain/usecases/chat/load_chat_room_usecase.dart';
import '../../domain/usecases/chat/send_message_usecase.dart';
import '../../domain/usecases/chat/receive_message_usecase.dart';
import '../../domain/usecases/chat/mark_chat_room_as_read_usecase.dart';
import '../../domain/usecases/chat/connect_livekit_usecase.dart';
import '../../domain/usecases/chat/disconnect_livekit_usecase.dart';
import '../../presentation/blocs/chat/chat_bloc.dart';
import '../services/livekit_service.dart';
import '../../core/services/address_external_service.dart';
import '../../data/datasources/address/address_remote_data_source.dart';
import '../../data/repositories/address_repository_impl.dart';
import '../../domain/repositories/address_repository.dart';
import '../../domain/usecases/address/get_addresses_usecase.dart';
import '../../domain/usecases/address/create_address_usecase.dart';
import '../../domain/usecases/address/update_address_usecase.dart';
import '../../domain/usecases/address/delete_address_usecase.dart';
import '../../domain/usecases/address/get_address_by_id_usecase.dart';
import '../../domain/usecases/address/set_default_shipping_address_usecase.dart';
import '../../domain/usecases/address/get_default_shipping_address_usecase.dart';
import '../../domain/usecases/address/get_addresses_by_type_usecase.dart';
import '../../domain/usecases/address/assign_address_to_shop_usecase.dart';
import '../../domain/usecases/address/get_addresses_by_shop_usecase.dart';
import '../../domain/usecases/address/get_provinces_usecase.dart';
import '../../domain/usecases/address/get_districts_usecase.dart';
import '../../domain/usecases/address/get_wards_usecase.dart';
import '../../presentation/blocs/address/address_bloc.dart';
import '../../data/datasources/products/product_variants_remote_data_source.dart';
import '../../data/repositories/product/product_variants_repository_impl.dart';
import '../../domain/repositories/product/product_variants_repository.dart';
import '../../domain/usecases/product_variants/get_product_variants_by_product_id.dart';
import '../../domain/usecases/product_variants/get_product_variant_by_id.dart';
import '../../domain/usecases/product_variants/check_variant_availability.dart';
import '../../domain/usecases/product_variants/get_cheapest_variant.dart';
import '../../domain/usecases/product_variants/get_available_variants.dart';
import '../../presentation/blocs/product_variants/product_variants_bloc.dart';



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

  getIt.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(getIt()), 
  );

  getIt.registerLazySingleton<ChatRepository>(
  () => ChatRepositoryImpl(getIt<ChatRemoteDataSource>()), 
);

  getIt.registerLazySingleton(() => LoadChatRoomsUseCase(getIt()));
  getIt.registerLazySingleton(() => LoadChatRoomsByShopUseCase(getIt()));
  getIt.registerLazySingleton(() => LoadShopChatRoomsUseCase(getIt()));
  getIt.registerLazySingleton(() => LoadChatRoomUseCase(getIt()));
  getIt.registerLazySingleton(() => SendMessageUseCase(getIt()));
  getIt.registerLazySingleton(() => ReceiveMessageUseCase(getIt()));
  getIt.registerLazySingleton(() => MarkChatRoomAsReadUseCase(getIt()));
  getIt.registerLazySingleton(() => ConnectLiveKitUseCase(getIt<LivekitService>()));
  getIt.registerLazySingleton(() => DisconnectLiveKitUseCase(getIt<LivekitService>()));

  // === PRODUCT VARIANTS DEPENDENCIES ===
  // Data sources
  getIt.registerLazySingleton<ProductVariantsRemoteDataSource>(
    () => ProductVariantsRemoteDataSourceImpl(dio: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<ProductVariantsRepository>(
    () => ProductVariantsRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetProductVariantsByProductId(getIt()));
  getIt.registerLazySingleton(() => GetProductVariantById(getIt()));
  getIt.registerLazySingleton(() => CheckVariantAvailability(getIt()));
  getIt.registerLazySingleton(() => GetCheapestVariant(getIt()));
  getIt.registerLazySingleton(() => GetAvailableVariants(getIt()));

  // Blocs
  getIt.registerFactory(() => ProductVariantsBloc(
    getProductVariantsByProductId: getIt(),
    getProductVariantById: getIt(),
    checkVariantAvailability: getIt(),
    getCheapestVariant: getIt(),
    getAvailableVariants: getIt(),
  ));


  // Register ChatBloc
  getIt.registerLazySingleton<ChatBloc>(() => ChatBloc(
    loadChatRoomUseCase: getIt(),
    loadChatRoomsByShopUseCase: getIt(),
    loadChatRoomsUseCase: getIt(),
    loadShopChatRoomsUseCase: getIt(),
    sendMessageUseCase: getIt(),
    receiveMessageUseCase: getIt(),
    markChatRoomAsReadUseCase: getIt(),
    connectLiveKitUseCase: getIt(),
    disconnectLiveKitUseCase: getIt(),
  ));
  
  //Livekit dependencies
  getIt.registerLazySingleton<LivekitService>(() => LivekitService(
    getIt(), 
    onStatusChanged: (status) {
      // Nếu muốn, có thể gửi event lên Bloc tại đây hoặc để Bloc tự set callback sau
      // Ví dụ: getIt<ChatBloc>().add(ChatLiveKitStatusChanged(status));
        getIt<ChatBloc>().add(ChatLiveKitStatusChanged(status));
    }
  ));

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

  // === ADDRESS DEPENDENCIES ===
  // Services
  getIt.registerLazySingleton<AddressExternalService>(
    () => AddressExternalService(getIt<Dio>()),
  );

  // Data sources
  getIt.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(getIt<Dio>(), getIt<AddressExternalService>()),
  );

  // Repositories
  getIt.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(
      remoteDataSource: getIt<AddressRemoteDataSource>(),
    ),
  );

  // Use cases - Core CRUD
  getIt.registerLazySingleton(() => GetAddressesUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => CreateAddressUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => UpdateAddressUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => DeleteAddressUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetAddressByIdUseCase(getIt<AddressRepository>()));

  // Use cases - Address Management
  getIt.registerLazySingleton(() => SetDefaultShippingAddressUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetDefaultShippingAddressUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetAddressesByTypeUseCase(getIt<AddressRepository>()));

  // Use cases - Shop Integration
  getIt.registerLazySingleton(() => AssignAddressToShopUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetAddressesByShopUseCase(getIt<AddressRepository>()));

  // Use cases - Location API
  getIt.registerLazySingleton(() => GetProvincesUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetDistrictsUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetWardsUseCase(getIt<AddressRepository>()));

  // Blocs
  getIt.registerFactory(() => AddressBloc(
    getAddressesUseCase: getIt(),
    createAddressUseCase: getIt(),
    updateAddressUseCase: getIt(),
    deleteAddressUseCase: getIt(),
    getAddressByIdUseCase: getIt(),
    setDefaultShippingAddressUseCase: getIt(),
    getDefaultShippingAddressUseCase: getIt(),
    getAddressesByTypeUseCase: getIt(),
    assignAddressToShopUseCase: getIt(),
    getAddressesByShopUseCase: getIt(),
    getProvincesUseCase: getIt(),
    getDistrictsUseCase: getIt(),
    getWardsUseCase: getIt(),
  ));
}
