import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/cart/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart/cart_remote_data_source.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CartResponseEntity>> addToCart(
    String productId,
    String? variantId,
    int quantity,
  ) async {
    try {
      final result = await remoteDataSource.addToCart(productId, variantId, quantity);
      return Right(CartResponseEntity(
        success: result.success,
        message: result.message,
        data: null,
        errors: result.errors,
      ));
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartDataEntity>> getCartItems() async {
    try {
      final response = await remoteDataSource.getCartItems();
      if (response.success && response.data != null) {
        return Right(response.data!.toEntity());
      } else {
        return Right(const CartDataEntity(
          cartId: '',
          customerId: '',
          totalProduct: 0,
          cartItemByShop: [],
        ));
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartResponseEntity>> updateCartItem(
    String cartItemId,
    int quantity,
  ) async {
    try {
      final result = await remoteDataSource.updateCartItem(cartItemId, quantity);
      return Right(CartResponseEntity(
        success: result.success,
        message: result.message,
        data: null,
        errors: result.errors,
      ));
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeCartItem(String cartItemId) async {
    try {
      final result = await remoteDataSource.removeCartItem(cartItemId);
      
      // Check if API actually deleted the item
      if (!result.success) {
        return Left(ServerFailure(result.message));
      }
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeMultipleCartItems(List<String> cartItemIds) async {
    try {
      await remoteDataSource.removeMultipleCartItems(cartItemIds);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await remoteDataSource.clearCart();
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PreviewOrderDataEntity>> getPreviewOrder(List<String> cartItemIds) async {
    try {
      final response = await remoteDataSource.getPreviewOrder(cartItemIds);
      if (response.success && response.data != null) {
        return Right(response.data!.toEntity());
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartSummaryEntity>> getCartSummary() async {
    try {
      final response = await remoteDataSource.getCartItems();
      if (response.success && response.data != null) {
        final cartData = response.data!;
        double totalAmount = 0;
        for (var shop in cartData.cartItemByShop) {
          totalAmount += shop.totalPriceInShop;
        }
        
        final cartSummary = CartSummaryEntity(
          totalItem: cartData.totalProduct,
          subTotal: totalAmount,
          discount: 0,
          totalAmount: totalAmount,
          listCartItem: cartData.cartItemByShop.map((shop) => shop.toEntity()).toList(),
        );
        
        return Right(cartSummary);
      } else {
        return Right(const CartSummaryEntity(
          totalItem: 0,
          subTotal: 0,
          discount: 0,
          totalAmount: 0,
          listCartItem: [],
        ));
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(
    String productId,
    String? variantId,
  ) async {
    return Left(ServerFailure('Method deprecated. Use removeCartItem() instead.'));
  }

  @override
  Future<Either<Failure, CartEntity>> getCartPreview() async {
    return Left(ServerFailure('Method deprecated. Use getPreviewOrder() instead.'));
  }

  Failure _handleDioException(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Yêu cầu không hợp lệ';
        return ServerFailure(message);
      case 401:
        return UnauthorizedFailure('Vui lòng đăng nhập để tiếp tục');
      case 403:
        return UnauthorizedFailure('Bạn không có quyền thực hiện hành động này');
      case 404:
        return ServerFailure('Không tìm thấy sản phẩm trong giỏ hàng');
      case 422:
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Dữ liệu không hợp lệ';
        return ServerFailure(message);
      case 500:
        return ServerFailure('Lỗi máy chủ, vui lòng thử lại sau');
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          return NetworkFailure('Hết thời gian kết nối');
        } else if (e.type == DioExceptionType.connectionError) {
          return NetworkFailure('Không có kết nối internet');
        } else {
          return NetworkFailure('Lỗi kết nối: ${e.message}');
        }
    }
  }
}