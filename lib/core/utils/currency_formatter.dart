import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(num amount, {String symbol = '₹', int decimalDigits = 2}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  static String formatWithoutDecimals(num amount, {String symbol = '₹'}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: symbol,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatCompact(num amount, {String symbol = '₹'}) {
    final formatter = NumberFormat.compactCurrency(
      locale: 'en_IN',
      symbol: symbol,
    );
    return formatter.format(amount);
  }
}