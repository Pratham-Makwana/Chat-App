import 'package:flutter/material.dart';

class MyDateUtil {
  /// for getting formatted time from milliSecondsSinceEpochs String
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  ///  last message time (user in chat card)
  static String getLastMessageTime(
      {required BuildContext context, required String time,bool showYear = false}) {
    final DateTime sentTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime currentTime = DateTime.now();

    if (currentTime.day == sentTime.day &&
        currentTime.month == sentTime.month &&
        currentTime.year == sentTime.year) {
      return TimeOfDay.fromDateTime(sentTime).format(context);
    }

    /// sentTime.month return integer so used switch case to get month
    return showYear ? '${sentTime.day} ${_getMonth(sentTime)} ${sentTime.year}': '${sentTime.day} ${_getMonth(sentTime)}';
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }

  /// get formatted active time of the user in chat screen
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    /// if time is not available then return this
    if (i == -1) return 'Last Seen  Not Available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return 'Last seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);
    return 'Last seen on ${time.day} $month on $formattedTime';
  }
}
