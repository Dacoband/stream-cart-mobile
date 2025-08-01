import 'package:dio/dio.dart';
import '../../models/cart/cart_model.dart';
import '../../../core/utils/api_url_helper.dart';

abstract class CartRemoteDataSource {
  Future<CartResponseModel> addToCart(CartItemModel cartItem);
  Future<List<CartItemModel>> getCartItems();
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
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final url = ApiUrlHelper.getFullUrl('/api/carts');
      final response = await dio.get(url);
      
      final data = response.data['data'];
      if (data != null && data['cartItemByShop'] != null) {
        List<CartItemModel> allItems = [];
        for (var shop in data['cartItemByShop']) {
          if (shop['products'] != null) {
            for (var product in shop['products']) {
              allItems.add(CartItemModel.fromJson(product));
            }
          }
        }
        return allItems;
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Vui lòng đăng nhập để xem giỏ hàng');
      } else if (e.response?.statusCode == 400) {
        // Kiểm tra message cụ thể từ server
        final responseData = e.response?.data;
        if (responseData != null && responseData['message'] == 'Không tìm thấy giỏ hàng') {
          // Giỏ hàng chưa được tạo - trả về empty list
          return [];
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
      final cartItems = await getCartItems();
      
      // Tìm cart item tương ứng
      CartItemModel? targetItem;
      for (var item in cartItems) {
        if (item.productId == productId && item.variantId == variantId) {
          targetItem = item;
          break;
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
      
      // Debug logging
      print('🔧 UpdateCartItem Request Data:');
      print('   productId: $productId');
      print('   variantId input: $variantId');
      print('   cartItemId: ${targetItem.cartItemId}');
      print('   quantity: $quantity');
      print('   URL: $url');
      print('   Full data: $data');
      
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
      // Sử dụng variantID thay vì variantId để match với API
      // Đảm bảo variantID là null nếu chuỗi rỗng hoặc null
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
      
      print('🗑️ RemoveCartItem Request:');
      print('   URL: $url');
      print('   CartItemId: $cartItemId');
      
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
    
    print('🔍 PreviewOrder Request:');
    print('   URL: $url');
    print('   CartItemIds: $cartItemIds');
    
    final response = await dio.get(url, queryParameters: data);
    
    print('🔍 PreviewOrder Response:');
    print('   Status: ${response.statusCode}');
    print('   Data: ${response.data}');
    
    return CartSummaryModel.fromJson(response.data['data']);
  }
}
