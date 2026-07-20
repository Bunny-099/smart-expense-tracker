import 'package:intl/intl.dart';
import 'extensions.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDate(DateTime date) {
    if (date.isToday) {
      return 'Today';
    } else if (date.isYesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM, yyyy').format(date);
    }
  }

  static String formatShortDate(DateTime date) {
    if (date.isToday) {
      return 'Today';
    } else if (date.isYesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM').format(date);
    }
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatDateTime(DateTime date) {
    final datePart = formatDate(date);
    final timePart = formatTime(date);
    return '$datePart, $timePart';
  }
}