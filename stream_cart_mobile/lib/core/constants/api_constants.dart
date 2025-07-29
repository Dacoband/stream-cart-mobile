class ApiConstants {
  // Base paths
  static const String authBasePath = '/api/auth';
  static const String userBasePath = '/api/account';
  static const String productBasePath = '/api/product';
  static const String imageBasePath = '/api/image';
    // Auth endpoints (matching .env file)
  static const String loginEndpoint = '/api/auth/login';
  static const String signupEndpoint = '/api/auth/register';
  static const String refreshTokenEndpoint = '/api/auth/refresh-token';
  static const String verifyAccountEndpoint = '/api/auth/verify';
  static const String resetPasswordRequestEndpoint = '/api/auth/reset-password-request';
  static const String resetPasswordEndpoint = '/api/auth/reset-password';
  static const String changePasswordEndpoint = '/api/auth/change-password';
  static const String getMeEndpoint = '/api/auth/me';
  
  // OTP endpoints
  static const String verifyOtpEndpoint = '/api/auth/verify-otp';
  static const String resendOtpEndpoint = '/api/auth/resend-otp';
  
  // Image endpoints
  static const String uploadImageEndpoint = '/api/image/upload';
  
  // Account endpoints
  static const String updateProfileEndpoint = '/api/account/{id}';

  // Address endpoints
  static const String addressEndpoint = '/api/address';
  static const String addressDetailEndpoint = '/api/address/{id}';
  static const String addressDeleteEndpoint = '/api/address/{id}';
  static const String addressSetDefaultEndpoint = '/api/address/{id}/set-default-shipping'; // PUT
  static const String addressDefaultShippingEndpoint = '/api/address/default-shipping'; // GET address mặc định
  static const String addressByTypeEndpoint = '/api/address/by-type/{type}'; // Lấy địa chỉ theo loại (shipping, billing)
  static const String addressAssignToShopEndpoint = '/api/address/{id}/assign-to-shop/{shopId}'; // Gán địa chỉ cho shop
  static const String addressUnAssignFromShopEndpoint = '/api/address/{id}/unassign-from-shop'; // Bỏ gán địa chỉ khỏi shop
  static const String addressByShopEndpoint = '/api/address/shops/{shopId}'; // Lấy địa chỉ của shop

  // Shop endpoints
  static const String shopsEndpoint = '/api/shops'; // Lấy tất cả shop
  static const String shopDetailEndpoint = '/api/shops/{id}';
  static const String shopSearchEndpoint = '/api/shops/search'; // Tìm kiếm shop theo tên

  
  // Product endpoints
  static const String productsEndpoint = '/api/products';
  static const String productDetailsEndpoint = '/api/products/{id}';
  static const String productDetailEndpoint = '/api/products/{id}/detail';
  static const String searchProductsEndpoint = '/api/products/search';
  static const String productsByShopEndpoint = '/api/products/shop/{shopId}'; // Lấy tất cả sản phẩm của shop đó
  static const String productFlashSaleEndpoint = '/api/products/flash-sale';
  
  // Flash Sale endpoints
  static const String flashSalesEndpoint = '/api/flashsales';
  static const String flashSaleDetailEndpoint = '/api/flashsales/{id}';
  
  // Product Image endpoints
  static const String allProductImagesEndpoint = '/api/product-images';
  static const String productImagesEndpoint = '/api/product-images/products/{productId}';
  
  // Other endpoints
  static const String categoriesEndpoint = '/api/categorys';
  static const String categoryDetailEndpoint = '/api/categorys/{id}';
  static const String productsByCategoryEndpoint = '/api/products/category/{id}';
  static const String cartEndpoint = '/api/carts';
  static const String cartPreviewEndpoint = '/api/carts/PreviewOrder';
  static const String ordersEndpoint = '/api/orders';
  
  // Notification endpoints
  static const String notificationEndpoint = '/api/notification';
  static const String markAsReadEndpoint = '/api/notification/mark-as-read';

  //Chat endpoints
  static const String chatEndpoint = '/api/chat/messages';
  static const String chatMessageEndpoint = '/api/chat/messages/{messageId}';
  static const String chatRoomEndpoint = '/api/chat/rooms';
  static const String chatRoomDetailsEndpoint = '/api/chat/rooms/{chatRoomId}/messages';
  static const String chatRoomMarkAsReadEndpoint = '/api/chat/rooms/{chatRoomId}/mark-read';
  static const String chatRoomShopEndpoint = '/api/chat/rooms/shop/{shopId}';
  static const String shopTokenEndpoint = '/api/chat/rooms/{chatRoomId}/shop-token';
  static const String chatShopRoomsEndpoint = '/api/chat/shop-rooms';

  
  // HTTP Status codes
  static const int successCode = 200;
  static const int createdCode = 201;
  static const int badRequestCode = 400;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int internalServerErrorCode = 500;
}