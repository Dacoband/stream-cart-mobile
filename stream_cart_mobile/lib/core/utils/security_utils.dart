import 'dart:convert';
import 'package:crypto/crypto.dart';

class SecurityUtils {
  /// Hash a password using SHA-256
  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate password strength
  static bool isValidPassword(String password) {
    // At least 8 characters, contains uppercase, lowercase, number and special character
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  /// Get password strength score (0-4)
  static int getPasswordStrength(String password) {
    int score = 0;
    
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    
    return score;
  }

  /// Get password strength text
  static String getPasswordStrengthText(String password) {
    int strength = getPasswordStrength(password);
    switch (strength) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Medium';
      case 4:
        return 'Strong';
      case 5:
        return 'Very Strong';
      default:
        return 'Unknown';
    }
  }

  /// Validate phone number (basic validation)
  static bool isValidPhoneNumber(String phone) {
    // Remove all non-digit characters
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Check if it's between 10-15 digits
    return cleanPhone.length >= 10 && cleanPhone.length <= 15;
  }
  /// Sanitize input string
  static String sanitizeInput(String input) {
    return input.trim()
        .replaceAll(RegExp(r'[<>"' "']"), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Generate a random string
  static String generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var random = DateTime.now().millisecondsSinceEpoch;
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random % chars.length)));
  }

  /// Mask sensitive data for logging
  static String maskSensitiveData(String data, {int visibleChars = 4}) {
    if (data.length <= visibleChars) {
      return '*' * data.length;
    }
    return data.substring(0, visibleChars) + '*' * (data.length - visibleChars);
  }

  /// Mask email for display
  static String maskEmail(String email) {
    if (!isValidEmail(email)) return email;
    
    var parts = email.split('@');
    var username = parts[0];
    var domain = parts[1];
    
    if (username.length <= 2) {
      return '${'*' * username.length}@$domain';
    }
    
    return '${username.substring(0, 2)}${'*' * (username.length - 2)}@$domain';
  }

  /// Mask phone number for display
  static String maskPhoneNumber(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length < 4) {
      return '*' * cleanPhone.length;
    }
    
    return '*' * (cleanPhone.length - 4) + cleanPhone.substring(cleanPhone.length - 4);
  }
}
