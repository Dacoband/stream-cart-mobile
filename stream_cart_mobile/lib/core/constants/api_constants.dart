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
  static const String countProductsByShopEndpoint = '/api/products/shop/{shopId}/count'; // Lấy số lượng sản phẩm của shop


  
  // Product endpoints
  static const String productsEndpoint = '/api/products';
  static const String productDetailsEndpoint = '/api/products/{id}';
  static const String productDetailEndpoint = '/api/products/{id}/detail';
  static const String searchProductsEndpoint = '/api/products/search';
  static const String productsByShopEndpoint = '/api/products/shop/{shopId}'; // Lấy tất cả sản phẩm của shop đó
  static const String productFlashSaleEndpoint = '/api/products/flash-sale';
  
  // Product Variant endpoints
  static const String productVariantsEndpoint = '/api/product-variants';
  static const String productVariantDetailEndpoint = '/api/product-variants/{id}';
  static const String productVariantByProductEndpoint = '/api/product-variants/product/{productId}';
  static const String productVariantsPriceEndpoint = '/api/product-variants/{id}/price'; //Patch
  static const String productVariantsStockEndpoint = '/api/product-variants/{id}/stock'; //Patch

  // Product Attribute endpoints
  static const String productAttributesEndpoint = '/api/product-attributes';
  static const String productAttributeDetailEndpoint = '/api/product-attributes/{id}';
  static const String productAttributesByProductEndpoint = '/api/product-attributes/products/{productId}';
  static const String productAttributesValuesEndpoint = '/api/product-attributes/{attributeId}/values'; // Lấy tất cả giá trị của thuộc tính sản phẩm

  // Attribute Value endpoints
  static const String attributeValuesEndpoint = '/api/attribute-values';
  static const String attributeValueDetailEndpoint = '/api/attribute-values/{id}';
  static const String attributeValuesByAttributeEndpoint = '/api/attribute-values/attribute/{attributeId}';


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

  // Cart endpoints
  static const String cartEndpoint = '/api/carts'; // GET, POST, PUT, DELETE
  static const String cartPreviewEndpoint = '/api/carts/PreviewOrder'; // Lấy thông tin giỏ hàng để preview đem trước khi tạo order

  // Order endpoints
  static const String ordersEndpoint = '/api/orders/multi'; //POST, tạo đơn hàng
  static const String orderDetailEndpoint = '/api/orders/{id}'; // GET, lấy chi tiết đơn hàng
  static const String orderCancelEndpoint = '/api/orders/{id}/cancel'; // POST, hủy đơn hàng
  static const String orderAccountEndpoint = '/api/orders/account/{accountId}'; // GET, lấy đơn hàng của tài khoản
  static const String orderPaymentStatusEndpoint = '/api/orders/{id}/payment-status'; // PUT, cập nhật trạng thái thanh toán của đơn hàng
  static const String orderStatusEndpoint = '/api/orders/{id}/status'; // PUT, cập nhật trạng thái của đơn hàng
  static const String orderShippingInfoEndpoint = '/api/orders/{id}/shipping-info'; // PUT, cập nhật thông tin vận chuyển của đơn hàng
  static const String orderTrackingCodeEndpoint = '/api/orders/{id}/tracking-code'; // PUT, cập nhật mã đơn của đơn hàng
  static const String orderCodeEndpoint = '/api/orders/{id}/code'; // GET, lấy đơn hàng theo mã đơn hàng


  // Order Item endpoints
  static const String orderItemsEndpoint = '/api/order-items/{id}'; // GET, PUT, DELETE 
  static const String orderItemsByOrderEndpoint = '/api/order-items/by-order/{orderId}'; // GET, lấy tất cả order item của đơn hàng
  static const String orderItemRefundRequestEndpoint = '/api/order-items/{orderItemId}/refund'; // POST, gửi yêu cầu hoàn tiền cho order item
  static const String createOrderItemByOrderEndpoint = '/api/order-items/orders/{orderId}'; // POST, tạo order item từ đơn hàng

  // Payment endpoints
  static const String paymentEndpoint = '/api/payments/generate-qr-code'; // POST, tạo thanh toán và generate QR code

// Delivery endpoints
  static const String deliveryEndpoint = '/api/deliveries/preview-order'; // POST

  // Notification endpoints
  static const String notificationEndpoint = '/api/notification';
  static const String markAsReadEndpoint = '/api/notification/mark-as-read';

  //Chat with SignalR endpoints
  static const String chatRoomEndpoint = '/api/chatsignalr/rooms'; // GET, POST
  static const String chatRoomDetailEndpoint = '/api/chatsignalr/rooms/{chatRoomId}'; // GET
  static const String chatRoomJoinEndpoint = '/api/chatsignalr/rooms/{chatRoomId}/join'; // POST
  static const String chatRoomLeaveEndpoint = '/api/chatsignalr/rooms/{chatRoomId}/leave'; // POST
  static const String chatRoomMarkReadEndpoint = '/api/chatsignalr/rooms/{chatRoomId}/mark-read'; // PATCH
  static const String chatRoomTypingEndpoint = '/api/chatsignalr/rooms/{chatRoomId}/typing'; // POST
  static const String chatRoomMessagesEndpoint = '/api/chatsignalr/rooms/{chatRoomId}/messages'; // GET
  static const String chatRoomMessagesSearchEndpoint = '/api/chatsignalr/rooms/{chatRoomId}/messages/search'; // GET
  static const String chatMessagesEndpoint = '/api/chatsignalr/messages'; // POST
  static const String chatMessagePutEndpoint = '/api/chatsignalr/messages/{messageId}'; // PUT
  static const String unReadCountEndpoint = '/api/chatsignalr/unread-count'; // GET
  static const String chatShopRoomsEndpoint = '/api/chatsignalr/shop-rooms'; // GET những phòng chat của shop

  // Livestream endpoints
  static const String getLiveStreamEndpoint =  '/api/livestreams/{id}'; // GET, lấy thông tin livestream
  static const String getJoinLiveStreamEndpoint =  '/api/livestreams/{id}/join'; // GET, tham gia livestream
  static const String getLiveStreamByShopIdEndpoint =  '/api/livestreams/shop/{shopId}'; // GET, lấy livestream theo shopId
  static const String getLiveStreamActiveEndpoint =  '/api/livestreams/active'; // GET, lấy livestream đang hoạt động

  // Product Livestream endpoints
  static const String getProductByLiveStreamIdEndpoint =  '/api/livestream-products/livestream/{livestreamId}'; // GET, lấy sản phẩm theo livestreamId

  // Chat in LiveStream endpoints
  static const String joinChatLiveStreamEndpoint =  '/api/chatsignalr/livestream/{livestreamId}/join'; // POST, tham gia chat livestream
  static const String sendMessageChatLiveStreamEndpoint =  '/api/chatsignalr/livestream/{livestreamId}/messages'; // POST, gửi tin nhắn trong chat livestream
  static const String getMessageChatLiveStreamEndpoint =  '/api/chatsignalr/livestream/{livestreamId}/messages'; // GET, lấy tin nhắn trong chat livestream

  // HTTP Status codes
  static const int successCode = 200;
  static const int createdCode = 201;
  static const int badRequestCode = 400;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int internalServerErrorCode = 500;
}