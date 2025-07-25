import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/failures.dart';
import '../../../domain/usecases/get_shops_usecase.dart';
import '../../../domain/entities/shop.dart';
import '../../../data/models/shop_model.dart';
import 'shop_event.dart';
import 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final GetShopsUseCase getShopsUseCase;
  final GetShopByIdUseCase getShopByIdUseCase;
  final GetProductsByShopUseCase getProductsByShopUseCase;

  ShopBloc({
    required this.getShopsUseCase,
    required this.getShopByIdUseCase,
    required this.getProductsByShopUseCase,
  }) : super(ShopInitial()) {
    on<LoadShops>(_onLoadShops);
    on<LoadShopDetail>(_onLoadShopDetail);
    on<LoadShopProducts>(_onLoadShopProducts);
    on<SearchShops>(_onSearchShops);
    on<RefreshShops>(_onRefreshShops);
  }

  Future<void> _onLoadShops(LoadShops event, Emitter<ShopState> emit) async {
    // If it's the first page, show loading
    if (event.pageNumber == 1) {
      emit(ShopLoading());
    } else {
      // If loading more pages, update state to show loading more
      if (state is ShopLoaded) {
        final currentState = state as ShopLoaded;
        emit(currentState.copyWith(isLoadingMore: true));
      }
    }

    final params = GetShopsParams(
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
      status: event.status,
      approvalStatus: event.approvalStatus,
      searchTerm: event.searchTerm,
      sortBy: event.sortBy,
      ascending: event.ascending,
    );

    final result = await getShopsUseCase(params);

    result.fold(
      (failure) {
        emit(ShopError(_mapFailureToMessage(failure)));
      },
      (shopResponse) {
        if (event.pageNumber == 1) {
          emit(ShopLoaded(
            shopResponse: shopResponse,
            hasReachedMax: shopResponse.items.length < event.pageSize,
          ));
        } else {
          if (state is ShopLoaded) {
            final currentState = state as ShopLoaded;
            final updatedShops = List<Shop>.from(currentState.shopResponse.items)
              ..addAll(shopResponse.items);

            final updatedResponse = ShopResponse(
              currentPage: shopResponse.currentPage,
              pageSize: shopResponse.pageSize,
              totalCount: shopResponse.totalCount,
              totalPages: shopResponse.totalPages,
              hasPrevious: shopResponse.hasPrevious,
              hasNext: shopResponse.hasNext,
              items: updatedShops,
            );

            emit(ShopLoaded(
              shopResponse: updatedResponse,
              hasReachedMax: !shopResponse.hasNext,
              isLoadingMore: false,
            ));
          }
        }
      },
    );
  }

  Future<void> _onLoadShopDetail(LoadShopDetail event, Emitter<ShopState> emit) async {
    emit(ShopDetailLoading());

    final result = await getShopByIdUseCase(event.shopId);

    result.fold(
      (failure) {
        emit(ShopError(_mapFailureToMessage(failure)));
      },
      (shop) {
        emit(ShopDetailLoaded(shop: shop));
      },
    );
  }

  Future<void> _onLoadShopProducts(LoadShopProducts event, Emitter<ShopState> emit) async {
    if (state is ShopDetailLoaded) {
      final currentState = state as ShopDetailLoaded;
      emit(currentState.copyWith(isLoadingProducts: true));

      print('🛍️ [DEBUG] ShopBloc - LoadShopProducts for shopId: ${event.shopId}');
      final result = await getProductsByShopUseCase(event.shopId);

      result.fold(
        (failure) {
          print('🛍️ [DEBUG] ShopBloc - LoadShopProducts FAILURE: $failure');
          emit(ShopError(_mapFailureToMessage(failure)));
        },
        (products) {
          print('🛍️ [DEBUG] ShopBloc - LoadShopProducts SUCCESS: $products');
          emit(currentState.copyWith(
            products: products,
            isLoadingProducts: false,
          ));
        },
      );
    }
  }

  Future<void> _onSearchShops(SearchShops event, Emitter<ShopState> emit) async {
    emit(ShopSearchLoading());

    final params = GetShopsParams(
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
      searchTerm: event.searchTerm,
    );

    final result = await getShopsUseCase(params);

    result.fold(
      (failure) {
        emit(ShopError(_mapFailureToMessage(failure)));
      },
      (shopResponse) {
        emit(ShopSearchLoaded(
          searchResults: shopResponse,
          searchTerm: event.searchTerm,
        ));
      },
    );
  }

  Future<void> _onRefreshShops(RefreshShops event, Emitter<ShopState> emit) async {
    add(const LoadShops(pageNumber: 1, pageSize: 10));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error. Please try again later.';
      case CacheFailure:
        return 'Cache Error. Please check your connection.';
      case NetworkFailure:
        return 'Network Error. Please check your internet connection.';
      default:
        return 'Unexpected Error. Please try again.';
    }
  }
}
