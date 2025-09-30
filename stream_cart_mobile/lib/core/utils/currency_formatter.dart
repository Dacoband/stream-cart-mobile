import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _vndFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
    decimalDigits: 0,
  );

  static String formatVND(num value, {bool withSuffix = true}) {
    final formatted = _vndFormatter.format(value).trim();
    if (!withSuffix) {
      return formatted;
    }
    return '$formattedđ';
  }
}
