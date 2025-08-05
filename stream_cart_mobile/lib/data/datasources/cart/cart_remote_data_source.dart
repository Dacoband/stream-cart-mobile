import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/cart/cart_response_model.dart';

abstract class CartRemoteDataSource {
  Future<GetCartResponseModel> getCartItems();
  Future<AddToCartResponseModel> addToCart(
    String productId,
    String? variantId,
    int quantity,
  );
  Future<UpdateCartResponseModel> updateCartItem(
    String cartItemId,
    int quantity,
  );
  Future<DeleteCartResponseModel> removeCartItem(String cartItemId);
  Future<DeleteCartResponseModel> removeMultipleCartItems(List<String> cartItemIds);
  Future<DeleteCartResponseModel> clearCart();
  Future<PreviewOrderResponseModel> getPreviewOrder(List<String> cartItemIds);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio _dioClient;

  CartRemoteDataSourceImpl({required Dio dioClient}) : _dioClient = dioClient;

  @override
  Future<GetCartResponseModel> getCartItems() async {
    try {
      final response = await _dioClient.get(
        ApiConstants.cartEndpoint, 
      );

      return GetCartResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to get cart items: $e');
    }
  }

  @override
  Future<AddToCartResponseModel> addToCart(
    String productId,
    String? variantId,
    int quantity,
  ) async {
    try {
      final requestData = {
        'productId': productId,
        if (variantId != null) 'variantId': variantId,
        'quantity': quantity,
      };

      final response = await _dioClient.post(
        ApiConstants.cartEndpoint, 
        data: requestData,
      );

      return AddToCartResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  @override
  Future<UpdateCartResponseModel> updateCartItem(
    String cartItemId,
    int quantity,
  ) async {
    try {
      // Need to get variant info first since API requires variantId
      final cartItems = await getCartItems();
      
      // Find the cart item to get its variantId
      String? variantId;
      if (cartItems.data != null) {
        for (var shop in cartItems.data!.cartItemByShop) {
          for (var product in shop.products) {
            if (product.cartItemId == cartItemId) {
              variantId = product.variantId;
              break;
            }
          }
          if (variantId != null) break;
        }
      }

      final response = await _dioClient.put(
        ApiConstants.cartEndpoint,
        data: {
          'cartItem': cartItemId,
          'variantId': variantId,
          'quantity': quantity,
        },
      );

      return UpdateCartResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  @override
  Future<DeleteCartResponseModel> removeCartItem(String cartItemId) async {
    try {
      final response = await _dioClient.delete(
        ApiConstants.cartEndpoint,
        queryParameters: {
          'id': cartItemId,
        },
      );

      return DeleteCartResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to remove cart item: $e');
    }
  }

  @override
  Future<DeleteCartResponseModel> removeMultipleCartItems(List<String> cartItemIds) async {
    try {
      final response = await _dioClient.delete(
        ApiConstants.cartEndpoint,
        queryParameters: {
          'id': cartItemIds,
        },
      );

      return DeleteCartResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to remove multiple cart items: $e');
    }
  }

  @override
  Future<DeleteCartResponseModel> clearCart() async {
    try {
      final response = await _dioClient.delete(
        ApiConstants.cartEndpoint,
      );

      return DeleteCartResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  @override
  Future<PreviewOrderResponseModel> getPreviewOrder(List<String> cartItemIds) async {
    try {
      final requestData = {
        'cartItemIds': cartItemIds,
      };

      final response = await _dioClient.post(
        ApiConstants.cartPreviewEndpoint,
        data: requestData,
      );

      return PreviewOrderResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to get preview order: $e');
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Request failed';
        return Exception('HTTP $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}