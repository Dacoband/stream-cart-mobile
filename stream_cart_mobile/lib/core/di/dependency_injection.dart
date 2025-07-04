import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/network/network_config.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/http_service.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/otp_usecases.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/home/home_bloc.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';

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
  getIt.registerLazySingleton(() => GetProductsUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchProductsUseCase(getIt()));
  
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
    searchProductsUseCase: getIt(),
  ));
  
  getIt.registerFactory(() => ProfileBloc(
    getUserProfileUseCase: getIt(),
  ));
}
