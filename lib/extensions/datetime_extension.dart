import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension DateTimeExtension on DateTime {
  String timeAgo() {
    final currentDateTime = DateTime.now();
    if (currentDateTime.difference(this).inDays > 1) {
      return DateFormat.yMMMd().format(this);
    }
    return timeago.format(this);
  }
}
