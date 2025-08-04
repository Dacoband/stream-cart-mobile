import 'package:flutter_dotenv/flutter_dotenv.dart';
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
import '../../domain/usecases/cart/get_all_cart_items_usecase.dart';
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
import '../../presentation/blocs/chat/chat_bloc.dart';
import '../../core/services/signalr_service.dart';
import '../../domain/usecases/chat/load_chat_rooms_usecase.dart';
import '../../domain/usecases/chat/load_chat_room_detail_usecase.dart';
import '../../domain/usecases/chat/load_chat_room_messages_usecase.dart';
import '../../domain/usecases/chat/search_chat_room_messages_usecase.dart';
import '../../domain/usecases/chat/create_chat_room_usecase.dart';
import '../../domain/usecases/chat/send_message_usecase.dart';
import '../../domain/usecases/chat/update_message_usecase.dart';
import '../../domain/usecases/chat/receive_message_usecase.dart';
import '../../domain/usecases/chat/mark_chat_room_as_read_usecase.dart';
import '../../domain/usecases/chat/send_typing_indicator_usecase.dart';
import '../../domain/usecases/chat/connect_signalr_usecase.dart';
import '../../domain/usecases/chat/disconnect_signalr_usecase.dart';
import '../../domain/usecases/chat/join_chat_room_usecase.dart';
import '../../domain/usecases/chat/leave_chat_room_usecase.dart';
import '../../domain/usecases/chat/get_unread_count_usecase.dart';
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
  // FIX 1: Load dotenv và reset GetIt ở ĐẦU
  await dotenv.load(fileName: ".env");
  await getIt.reset();
  
  // Declare SignalR URLs after dotenv is loaded
  String signalRChatBaseUrl = dotenv.env['SIGNALR_CHAT_BASE_URL']!;

  // Core services
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  getIt.registerLazySingleton<StorageService>(() => StorageService(getIt()));
  HttpService.initialize(storageService: getIt<StorageService>());
  getIt.registerLazySingleton<Dio>(() => NetworkConfig.createDio(storageService: getIt()));

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(getIt<FlutterSecureStorage>()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    remoteDataSource: getIt(),
    localDataSource: getIt(),
  ));
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => ResendOtpUseCase(getIt()));

  // Home
  getIt.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerLazySingleton(() => GetCategoriesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCategoryDetailUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductsByCategoryUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductsUseCase(getIt()));
  getIt.registerLazySingleton(() => search.SearchProductsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductDetailUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductImagesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductPrimaryImagesUseCase(getIt()));

  // Advanced Search
  getIt.registerLazySingleton<SearchRemoteDataSource>(() => SearchRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(getIt()));
  getIt.registerLazySingleton(() => SearchProductsAdvancedUseCase(getIt()));

  // Flash Sale
  getIt.registerLazySingleton<FlashSaleRemoteDataSource>(() => FlashSaleRemoteDataSourceImpl(dio: getIt()));
  getIt.registerLazySingleton<FlashSaleRepository>(() => FlashSaleRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerLazySingleton(() => GetFlashSalesUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetFlashSaleProductsUseCase(repository: getIt()));

  // Search service, Image upload
  getIt.registerLazySingleton(() => SearchHistoryService());
  getIt.registerLazySingleton(() => ImageUploadService(getIt()));

  // Profile
  getIt.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerLazySingleton(() => GetUserProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserProfileUseCase(getIt()));

  // Cart
  getIt.registerLazySingleton<CartRemoteDataSource>(() => CartRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(getIt()));
  getIt.registerLazySingleton(() => AddToCartUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCartItemsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllCartItemsUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateCartItemUseCase(getIt()));
  getIt.registerLazySingleton(() => RemoveFromCartUseCase(getIt()));
  getIt.registerLazySingleton(() => RemoveCartItemUseCase(getIt()));
  getIt.registerLazySingleton(() => RemoveMultipleCartItemsUseCase(getIt()));
  getIt.registerLazySingleton(() => ClearCartUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCartPreviewUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPreviewOrderUseCase(getIt()));

  // Shop
  getIt.registerLazySingleton<ShopRemoteDataSource>(() => ShopRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<ShopRepository>(() => ShopRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerLazySingleton(() => GetShopsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetShopByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductsByShopUseCase(getIt()));

  // === CHAT (SignalR only) ===
  // Data sources
  getIt.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(dio: getIt<Dio>()));

  // Repositories
  getIt.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remoteDataSource: getIt<ChatRemoteDataSource>()));

  // SignalR Service 
  getIt.registerLazySingleton<SignalRService>(() => SignalRService(
    signalRChatBaseUrl,  // Use local variable
    getIt<StorageService>(),
    onStatusChanged: (status) {
      print('SignalR Status: $status');
    },
  ));

  // Use cases 
  getIt.registerLazySingleton(() => LoadChatRoomsUseCase(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => LoadChatRoomDetailUseCase(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => LoadChatRoomMessagesUseCase(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => SearchChatRoomMessagesUseCase(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => CreateChatRoomUseCase(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => SendMessageUseCase(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => UpdateMessageUseCase(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => ReceiveMessageUseCase());
  getIt.registerLazySingleton(() => MarkChatRoomAsReadUseCase(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => SendTypingIndicatorUseCase(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => ConnectSignalRUseCase(getIt<SignalRService>()));
  getIt.registerLazySingleton(() => DisconnectSignalRUseCase(getIt<SignalRService>()));
  getIt.registerLazySingleton(() => JoinChatRoomUseCase(getIt<SignalRService>()));
  getIt.registerLazySingleton(() => LeaveChatRoomUseCase(getIt<SignalRService>()));
  getIt.registerLazySingleton(() => LoadShopChatRoomsUseCase(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => GetUnreadCountUseCase(getIt<ChatRepository>()));

  // ChatBloc
  getIt.registerLazySingleton<ChatBloc>(() => ChatBloc(
    loadChatRoomsUseCase: getIt(),
    loadChatRoomDetailUseCase: getIt(),
    loadChatRoomMessagesUseCase: getIt(),
    searchChatRoomMessagesUseCase: getIt(),
    createChatRoomUseCase: getIt(),
    sendMessageUseCase: getIt(),
    updateMessageUseCase: getIt(),
    receiveMessageUseCase: getIt(),
    markChatRoomAsReadUseCase: getIt(),
    sendTypingIndicatorUseCase: getIt(),
    connectSignalRUseCase: getIt(),
    disconnectSignalRUseCase: getIt(),
    joinChatRoomUseCase: getIt(),
    leaveChatRoomUseCase: getIt(),
    loadShopChatRoomsUseCase: getIt(),
    getUnreadCountUseCase: getIt(),
    signalRService: getIt(),
  ));

  // === PRODUCT VARIANTS === 
  getIt.registerLazySingleton<ProductVariantsRemoteDataSource>(() => ProductVariantsRemoteDataSourceImpl(dio: getIt()));
  getIt.registerLazySingleton<ProductVariantsRepository>(() => ProductVariantsRepositoryImpl(getIt()));
  getIt.registerLazySingleton(() => GetProductVariantsByProductId(getIt()));
  getIt.registerLazySingleton(() => GetProductVariantById(getIt()));
  getIt.registerLazySingleton(() => CheckVariantAvailability(getIt()));
  getIt.registerLazySingleton(() => GetCheapestVariant(getIt()));
  getIt.registerLazySingleton(() => GetAvailableVariants(getIt()));
  
  // FIX 2: ProductVariantsBloc - CHỈ register 1 LẦN
  getIt.registerFactory(() => ProductVariantsBloc(
    getProductVariantsByProductId: getIt(),
    getProductVariantById: getIt(),
    checkVariantAvailability: getIt(),
    getCheapestVariant: getIt(),
    getAvailableVariants: getIt(),
  ));

  // === NOTIFICATION ===
  getIt.registerLazySingleton<NotificationRemoteDataSource>(() => NotificationRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(getIt()));
  getIt.registerLazySingleton(() => GetNotificationsUseCase(getIt()));
  getIt.registerLazySingleton(() => MarkNotificationAsReadUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUnreadNotificationCountUseCase(getIt()));

  // === ADDRESS ===
  getIt.registerLazySingleton<AddressExternalService>(() => AddressExternalService(getIt<Dio>()));
  getIt.registerLazySingleton<AddressRemoteDataSource>(() => AddressRemoteDataSourceImpl(getIt<Dio>(), getIt<AddressExternalService>()));
  getIt.registerLazySingleton<AddressRepository>(() => AddressRepositoryImpl(remoteDataSource: getIt<AddressRemoteDataSource>()));
  getIt.registerLazySingleton(() => GetAddressesUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => CreateAddressUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => UpdateAddressUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => DeleteAddressUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetAddressByIdUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => SetDefaultShippingAddressUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetDefaultShippingAddressUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetAddressesByTypeUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => AssignAddressToShopUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetAddressesByShopUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetProvincesUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetDistrictsUseCase(getIt<AddressRepository>()));
  getIt.registerLazySingleton(() => GetWardsUseCase(getIt<AddressRepository>()));

  // === BLOCS === (Factory registrations)
  getIt.registerLazySingleton<AuthBloc>(() => AuthBloc(
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

  getIt.registerFactory(() => NotificationBloc(
    getNotificationsUseCase: getIt(),
    markNotificationAsReadUseCase: getIt(),
    getUnreadNotificationCountUseCase: getIt(),
  ));

  getIt.registerFactory(() => ShopBloc(
    getShopsUseCase: getIt(),
    getShopByIdUseCase: getIt(),
    getProductsByShopUseCase: getIt(),
  ));

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

  // CartBloc as singleton (keep this at the end)
  getIt.registerLazySingleton(() {
    final cartBloc = CartBloc(
      addToCartUseCase: getIt(),
      getCartItemsUseCase: getIt(),
      getAllCartItemsUseCase: getIt(),
      updateCartItemUseCase: getIt(),
      removeFromCartUseCase: getIt(),
      removeCartItemUseCase: getIt(),
      removeMultipleCartItemsUseCase: getIt(),
      clearCartUseCase: getIt(),
      getCartPreviewUseCase: getIt(),
      getPreviewOrderUseCase: getIt(),
    );
    return cartBloc;
  });
}
