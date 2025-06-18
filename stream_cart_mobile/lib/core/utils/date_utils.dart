import 'package:intl/intl.dart';

class DateUtils {
  /// Format date to readable string
  static String formatDate(DateTime date, {String pattern = 'MMM dd, yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  /// Format date and time to readable string
  static String formatDateTime(DateTime dateTime, {String pattern = 'MMM dd, yyyy HH:mm'}) {
    return DateFormat(pattern).format(dateTime);
  }

  /// Format time to readable string
  static String formatTime(DateTime time, {String pattern = 'HH:mm'}) {
    return DateFormat(pattern).format(time);
  }

  /// Get relative time string (e.g., "2 hours ago", "Just now")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  /// Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
           date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Get age from date of birth
  static int getAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    
    return age;
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysToSunday)));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    final nextMonth = date.month == 12 
        ? DateTime(date.year + 1, 1, 1)
        : DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(microseconds: 1));
  }

  /// Add business days (excluding weekends)
  static DateTime addBusinessDays(DateTime date, int days) {
    DateTime result = date;
    int addedDays = 0;
    
    while (addedDays < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday <= 5) { // Monday to Friday
        addedDays++;
      }
    }
    
    return result;
  }

  /// Count business days between two dates
  static int countBusinessDays(DateTime start, DateTime end) {
    if (start.isAfter(end)) return 0;
    
    int count = 0;
    DateTime current = start;
    
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      if (current.weekday <= 5) { // Monday to Friday
        count++;
      }
      current = current.add(const Duration(days: 1));
    }
    
    return count;
  }

  /// Parse date string with multiple format support
  static DateTime? parseDate(String dateString) {
    final formats = [
      'yyyy-MM-dd',
      'MM/dd/yyyy',
      'dd/MM/yyyy',
      'yyyy-MM-dd HH:mm:ss',
      'MM/dd/yyyy HH:mm:ss',
      'dd/MM/yyyy HH:mm:ss',
      'MMM dd, yyyy',
      'dd MMM yyyy',
    ];
    
    for (final format in formats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (e) {
        // Continue to next format
      }
    }
    
    // Try ISO 8601 format
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Check if year is leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Get days in month
  static int getDaysInMonth(int year, int month) {
    switch (month) {
      case 2:
        return isLeapYear(year) ? 29 : 28;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      default:
        return 31;
    }
  }

  /// Get time zone offset string
  static String getTimeZoneOffset(DateTime date) {
    final offset = date.timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60).abs();
    
    final sign = hours >= 0 ? '+' : '-';
    final hoursStr = hours.abs().toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    
    return '$sign$hoursStr:$minutesStr';
  }

  /// Convert UTC to local time
  static DateTime utcToLocal(DateTime utcDate) {
    return utcDate.toLocal();
  }

  /// Convert local time to UTC
  static DateTime localToUtc(DateTime localDate) {
    return localDate.toUtc();
  }
}
