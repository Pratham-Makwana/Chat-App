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
      {required BuildContext context, required String time}) {
    final DateTime sentTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime currentTime = DateTime.now();

    if (currentTime.day == sentTime.day &&
        currentTime.month == sentTime.month &&
        currentTime.year == sentTime.year) {
      return TimeOfDay.fromDateTime(sentTime).format(context);
    }

    /// sentTime.month return integer so used switch case to get month
    return '${sentTime.day} ${_getMonth(sentTime)}';
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
}
