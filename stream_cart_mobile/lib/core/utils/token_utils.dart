import 'dart:convert';

class TokenUtils {
  /// Check if JWT token is expired
  static bool isTokenExpired(String token) {
    try {
      // JWT has 3 parts separated by dots
      final parts = token.split('.');
      if (parts.length != 3) return true;
      
      // Decode payload (middle part)
      final payload = parts[1];
      // Add padding if needed
      final padded = payload + '=' * (4 - payload.length % 4);
      final decoded = base64.decode(padded);
      final jsonPayload = json.decode(utf8.decode(decoded));
      
      // Check expiry time
      final exp = jsonPayload['exp'];
      if (exp == null) return true;
      
      final expiryTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();
      
      // Add 5 minute buffer to refresh before actual expiry
      final buffer = const Duration(minutes: 5);
      return now.add(buffer).isAfter(expiryTime);
    } catch (e) {
      print('Error checking token expiry: $e');
      return true; // Consider expired if we can't parse
    }
  }
  
  /// Extract user ID from JWT token
  static String? getUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      final payload = parts[1];
      final padded = payload + '=' * (4 - payload.length % 4);
      final decoded = base64.decode(padded);
      final jsonPayload = json.decode(utf8.decode(decoded));
      
      return jsonPayload['sub'] ?? jsonPayload['userId'] ?? jsonPayload['id'];
    } catch (e) {
      print('Error extracting user ID from token: $e');
      return null;
    }
  }
  
  /// Get token expiry time
  static DateTime? getTokenExpiryTime(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      final payload = parts[1];
      final padded = payload + '=' * (4 - payload.length % 4);
      final decoded = base64.decode(padded);
      final jsonPayload = json.decode(utf8.decode(decoded));
      
      final exp = jsonPayload['exp'];
      if (exp == null) return null;
      
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (e) {
      print('Error getting token expiry time: $e');
      return null;
    }
  }
}
