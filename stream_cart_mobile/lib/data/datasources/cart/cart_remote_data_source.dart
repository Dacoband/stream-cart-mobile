import 'package:dio/dio.dart';
import '../../models/cart/cart_model.dart';
import '../../models/cart/cart_response_model.dart';
import '../../../core/utils/api_url_helper.dart';

abstract class CartRemoteDataSource {
  Future<CartResponseModel> addToCart(CartItemModel cartItem);
  Future<GetCartResponseModel> getCartItems();
  Future<CartResponseModel> updateCartItem(String productId, String? variantId, int quantity);
  Future<void> removeFromCart(String productId, String? variantId);
  Future<void> removeCartItem(String cartItemId);
  Future<void> clearCart();
  Future<CartModel> getCartPreview();
  Future<CartSummaryModel> getPreviewOrder(List<String> cartItemIds);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio dio;

  CartRemoteDataSourceImpl(this.dio);

  @override
  Future<CartResponseModel> addToCart(CartItemModel cartItem) async {
    try {
      final url = ApiUrlHelper.getFullUrl('/api/carts');
      final response = await dio.post(url, data: cartItem.toJson());
      return CartResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng');
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        if (responseData != null && responseData['message'] != null) {
          throw Exception(responseData['message']);
        }
        throw Exception('Không thể thêm sản phẩm vào giỏ hàng');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  @override
  Future<GetCartResponseModel> getCartItems() async {
    try {
      final url = ApiUrlHelper.getFullUrl('/api/carts');
      final response = await dio.get(url);
      
      return GetCartResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Vui lòng đăng nhập để xem giỏ hàng');
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        if (responseData != null && responseData['message'] == 'Không tìm thấy giỏ hàng') {
          // Giỏ hàng chưa được tạo - trả về empty cart response
          return GetCartResponseModel(
            success: true,
            message: 'Giỏ hàng trống',
            data: null,
            errors: [],
          );
        }
        throw Exception('Yêu cầu không hợp lệ');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  @override
  Future<CartResponseModel> updateCartItem(String productId, String? variantId, int quantity) async {
    try {
      // Trước tiên get cart items để tìm cartItemId
      final cartResponse = await getCartItems();
      
      // Tìm cart item tương ứng
      CartItemModel? targetItem;
      
      if (cartResponse.data != null && cartResponse.data!.cartItemByShop.isNotEmpty) {
        for (var shop in cartResponse.data!.cartItemByShop) {
          for (var product in shop.products) {
            if (product.productId == productId && product.variantId == variantId) {
              targetItem = product;
              break;
            }
          }
          if (targetItem != null) break;
        }
      }
      
      if (targetItem == null) {
        throw Exception('Không tìm thấy sản phẩm trong giỏ hàng');
      }
      
      // Sử dụng PUT endpoint theo API spec
      final url = ApiUrlHelper.getFullUrl('/api/carts');
      
      final data = {
        'cartItem': targetItem.cartItemId,
        'variantId': variantId ?? targetItem.variantId,
        'quantity': quantity,
      };
      final response = await dio.put(url, data: data);
      return CartResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Vui lòng đăng nhập để cập nhật giỏ hàng');
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        if (responseData != null && responseData['message'] != null) {
          throw Exception(responseData['message']);
        }
        throw Exception('Không thể cập nhật sản phẩm trong giỏ hàng');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Không tìm thấy sản phẩm trong giỏ hàng');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  @override
  Future<void> removeFromCart(String productId, String? variantId) async {
    try {
      final url = ApiUrlHelper.getFullUrl('/api/carts');
      await dio.delete(url, data: {
        'productId': productId,
        'variantID': (variantId == null || variantId.isEmpty) ? null : variantId,
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        if (responseData != null && responseData['message'] != null) {
          throw Exception(responseData['message']);
        }
        throw Exception('Không thể xóa sản phẩm khỏi giỏ hàng');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  @override
  Future<void> removeCartItem(String cartItemId) async {
    try {
      final url = ApiUrlHelper.getFullUrl('/api/carts');
      
      await dio.delete(url, queryParameters: {
        'id': cartItemId,
      });
      
      print('✅ Cart item removed successfully');
    } on DioException catch (e) {
      print('❌ RemoveCartItem Error: ${e.response?.statusCode} - ${e.message}');
      if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        if (responseData != null && responseData['message'] != null) {
          throw Exception(responseData['message']);
        }
        throw Exception('Không thể xóa sản phẩm khỏi giỏ hàng');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Không tìm thấy sản phẩm trong giỏ hàng');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      print('❌ RemoveCartItem Unexpected Error: $e');
      throw Exception('Lỗi không xác định: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    final url = ApiUrlHelper.getFullUrl('/api/carts');
    await dio.delete(url);
  }

  @override
  Future<CartModel> getCartPreview() async {
    final url = ApiUrlHelper.getFullUrl('/api/carts/PreviewOrder');
    final response = await dio.get(url);
    return CartModel.fromJson(response.data['data']);
  }

  @override
  Future<CartSummaryModel> getPreviewOrder(List<String> cartItemIds) async {
    final url = ApiUrlHelper.getFullUrl('/api/carts/PreviewOrder');
    final data = {
      'cartItemId': cartItemIds,
    };
    final response = await dio.get(url, queryParameters: data);
    return CartSummaryModel.fromJson(response.data['data']);
  }
}
