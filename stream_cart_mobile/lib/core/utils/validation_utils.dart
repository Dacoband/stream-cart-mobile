class ValidationUtils {
  /// Validate email format using regex
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'
    );
    
    return emailRegex.hasMatch(email);
  }

  /// Validate password with multiple criteria
  static Map<String, bool> validatePassword(String password) {
    return {
      'minLength': password.length >= 8,
      'hasUppercase': RegExp(r'[A-Z]').hasMatch(password),
      'hasLowercase': RegExp(r'[a-z]').hasMatch(password),
      'hasDigits': RegExp(r'[0-9]').hasMatch(password),
      'hasSpecialChar': RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
    };
  }

  /// Check if password is strong (meets all criteria)
  static bool isStrongPassword(String password) {
    final validation = validatePassword(password);
    return validation.values.every((isValid) => isValid);
  }

  /// Get password strength as percentage
  static double getPasswordStrengthPercentage(String password) {
    final validation = validatePassword(password);
    final passedCriteria = validation.values.where((isValid) => isValid).length;
    return (passedCriteria / validation.length) * 100;
  }

  /// Validate phone number (international format)
  static bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;
    
    // Remove all non-digit characters
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Check for international format or local format
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    
    return phoneRegex.hasMatch(cleanPhone) && cleanPhone.length >= 10;
  }

  /// Validate name (letters, spaces, hyphens, apostrophes only)
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    return nameRegex.hasMatch(name.trim()) && name.trim().length >= 2;
  }

  /// Validate username (alphanumeric, underscore, hyphen)
  static bool isValidUsername(String username) {
    if (username.isEmpty) return false;
    
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]{3,20}$');
    return usernameRegex.hasMatch(username);
  }

  /// Validate URL format
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Validate age (must be between min and max)
  static bool isValidAge(int age, {int minAge = 13, int maxAge = 120}) {
    return age >= minAge && age <= maxAge;
  }

  /// Validate date of birth
  static bool isValidDateOfBirth(DateTime? dateOfBirth, {int minAge = 13}) {
    if (dateOfBirth == null) return false;
    
    final now = DateTime.now();
    final age = now.year - dateOfBirth.year;
    
    // Check if birthday has occurred this year
    final hasHadBirthdayThisYear = now.month > dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day >= dateOfBirth.day);
    
    final actualAge = hasHadBirthdayThisYear ? age : age - 1;
    
    return isValidAge(actualAge, minAge: minAge);
  }

  /// Validate credit card number using Luhn algorithm
  static bool isValidCreditCard(String cardNumber) {
    if (cardNumber.isEmpty) return false;
    
    final cleanNumber = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return false;
    }
    
    return _luhnCheck(cleanNumber);
  }

  /// Luhn algorithm for credit card validation
  static bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool alternate = false;
    
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return sum % 10 == 0;
  }

  /// Validate postal code (basic validation)
  static bool isValidPostalCode(String postalCode, {String? countryCode}) {
    if (postalCode.isEmpty) return false;
    
    switch (countryCode?.toUpperCase()) {
      case 'US':
        return RegExp(r'^\d{5}(-\d{4})?$').hasMatch(postalCode);
      case 'CA':
        return RegExp(r'^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$').hasMatch(postalCode);
      case 'UK':
      case 'GB':
        return RegExp(r'^[A-Za-z]{1,2}\d[A-Za-z\d]?\s?\d[A-Za-z]{2}$').hasMatch(postalCode);
      default:
        // Generic validation - 3 to 10 alphanumeric characters
        return RegExp(r'^[A-Za-z0-9\s-]{3,10}$').hasMatch(postalCode);
    }
  }

  /// Get validation error message for email
  static String? getEmailErrorMessage(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Get validation error messages for password
  static List<String> getPasswordErrorMessages(String password) {
    final validation = validatePassword(password);
    final errors = <String>[];
    
    if (!validation['minLength']!) {
      errors.add('Password must be at least 8 characters long');
    }
    if (!validation['hasUppercase']!) {
      errors.add('Password must contain at least one uppercase letter');
    }
    if (!validation['hasLowercase']!) {
      errors.add('Password must contain at least one lowercase letter');
    }
    if (!validation['hasDigits']!) {
      errors.add('Password must contain at least one number');
    }
    if (!validation['hasSpecialChar']!) {
      errors.add('Password must contain at least one special character');
    }
    
    return errors;
  }

  /// Get validation error message for phone
  static String? getPhoneErrorMessage(String phone) {
    if (phone.isEmpty) {
      return 'Phone number is required';
    }
    if (!isValidPhoneNumber(phone)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Get validation error message for name
  static String? getNameErrorMessage(String name, {String fieldName = 'Name'}) {
    if (name.isEmpty) {
      return '$fieldName is required';
    }
    if (!isValidName(name)) {
      return 'Please enter a valid $fieldName (letters only)';
    }
    return null;
  }
}
