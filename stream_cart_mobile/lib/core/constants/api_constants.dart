class ApiConstants {
  // Base paths
  static const String authBasePath = '/api/auth';
  static const String userBasePath = '/api/user';
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
  
  // User endpoints
  static const String profileEndpoint = '/api/user/profile';
  static const String updateProfileEndpoint = '/api/user/profile';
  
  // Product endpoints
  static const String productsEndpoint = '/api/product';
  static const String productDetailsEndpoint = '/api/product/{id}';
  static const String searchProductsEndpoint = '/api/product/search';
  
  // Other endpoints
  static const String categoriesEndpoint = '/api/categories';
  static const String cartEndpoint = '/api/cart';
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