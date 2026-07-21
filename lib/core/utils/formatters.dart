import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String currency(double amount, {String symbol = '₹'}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount, {String symbol = '₹'}) {
    final absAmount = amount.abs();
    final prefix = amount < 0 ? '-' : '';
    String formatted;

    if (absAmount >= 10000000) {
      final val = absAmount / 10000000;
      formatted = '${val % 1 == 0 ? val.toInt() : val.toStringAsFixed(1)}Cr';
    } else if (absAmount >= 100000) {
      final val = absAmount / 100000;
      formatted = '${val % 1 == 0 ? val.toInt() : val.toStringAsFixed(1)}L';
    } else if (absAmount >= 1000) {
      final val = absAmount / 1000;
      formatted = '${val % 1 == 0 ? val.toInt() : val.toStringAsFixed(1)}K';
    } else {
      formatted = absAmount.toStringAsFixed(0);
    }

    return '$prefix$symbol$formatted';
  }

  static String date(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0 && now.day == date.day) {
      return 'Today';
    } else if (difference == 1 || (difference == 0 && now.day != date.day)) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }
}