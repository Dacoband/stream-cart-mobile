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
import '../../presentation/blocs/auth/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Core Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(() {
    try {
      return const FlutterSecureStorage();
    } catch (e) {
      print('FlutterSecureStorage not available on this platform');
      rethrow;
    }
  });
  
  // Storage Service
  getIt.registerLazySingleton<StorageService>(() => StorageService(getIt()));
  
  // HTTP Service
  HttpService.initialize(storageService: getIt<StorageService>());
  
  // Core
  getIt.registerLazySingleton<Dio>(() => NetworkConfig.createDio(storageService: getIt()));
  
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () {
      FlutterSecureStorage? secureStorage;
      try {
        secureStorage = getIt<FlutterSecureStorage>();
      } catch (e) {
        print('FlutterSecureStorage not available on this platform, using fallback');
        secureStorage = null;
      }
      return AuthLocalDataSourceImpl(secureStorage);
    },
  );
    // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  
  // Services
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt()));
  
  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  
  // Blocs
  getIt.registerFactory(() => AuthBloc(loginUseCase: getIt()));
}
