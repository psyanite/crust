import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class TimeUtil {
  static String toString(DateTime time) {
    var result = timeago.format(time);
    if (result == 'about a year ago') {
      return new DateFormat.yMMMMd("en_US").format(time);
    }
    return result;
  }
}
