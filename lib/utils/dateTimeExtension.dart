import 'package:edemand_partner/utils/constant.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  bool isSameAs(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool isToday() {
    return isSameAs(DateTime.now());
  }

  bool isYesterday() {
    return isSameAs(DateTime.now().subtract(const Duration(days: 1)));
  }

  bool isCurrentYear() {
    return year == DateTime.now().year;
  }

  /// Date in the country format from [dateAndTimeSetting].
  String formatDate() =>
      DateFormat(dateAndTimeSetting["dateFormat"]).format(this);
}
