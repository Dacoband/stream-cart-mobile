import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_model.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CartResponseEntity>> addToCart(
    String productId,
    String variantId,
    int quantity,
  ) async {
    try {
      final cartItem = CartItemModel(
        productId: productId,
        variantId: variantId,
        quantity: quantity,
      );
      final result = await remoteDataSource.addToCart(cartItem);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final cartItems = await remoteDataSource.getCartItems();
      return Right(cartItems.map((item) => item.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartResponseEntity>> updateCartItem(
    String productId,
    String? variantId,
    int quantity,
  ) async {
    try {
      final result = await remoteDataSource.updateCartItem(productId, variantId, quantity);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để cập nhật giỏ hàng'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Không thể cập nhật sản phẩm trong giỏ hàng';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy sản phẩm trong giỏ hàng'));
      } else {
        return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
      }
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(
    String productId,
    String? variantId,
  ) async {
    try {
      await remoteDataSource.removeFromCart(productId, variantId);
      return const Right(null);
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
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> getCartPreview() async {
    try {
      final cart = await remoteDataSource.getCartPreview();
      return Right(cart.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
