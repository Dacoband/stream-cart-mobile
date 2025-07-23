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
  
  // Product endpoints
  static const String productsEndpoint = '/api/products';
  static const String productDetailsEndpoint = '/api/products/{id}';
  static const String productDetailEndpoint = '/api/products/{id}/detail';
  static const String searchProductsEndpoint = '/api/products/search';
  
  // Flash Sale endpoints
  static const String flashSalesEndpoint = '/api/flashsales';
  
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
  
  // HTTP Status codes
  static const int successCode = 200;
  static const int createdCode = 201;
  static const int badRequestCode = 400;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int internalServerErrorCode = 500;
}