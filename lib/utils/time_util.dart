import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class TimeUtil {
  static String format(DateTime time) {
    var result = timeago.format(time);
    if (result == 'about a year ago') {
      return DateFormat.yMMMMd("en_US").format(time);
    }
    return result;
  }
}
