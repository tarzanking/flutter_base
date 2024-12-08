import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottery/res/label.dart';
import 'package:lottery/utils/data_extension.dart';

class DateManager {
  static const String dateFormat = 'dd/MM/yyyy';

  static String formatDateToString(DateTime? dateTime,
      {String dateFormat = dateFormat}) {
    try {
      if (dateTime != null) {
        return DateFormat(dateFormat, Get.locale?.languageCode).format(dateTime);
      } else {
        return '';
      }
    } catch (ex) {
      return '';
    }
  }

  static DateTime? formatStringToDate(String date,
      {String dateFormat = dateFormat}) {
    try {
      return DateFormat(dateFormat).parse(date);
    } catch (ex) {
      return null;
    }
  }

  static int? formatStringToTimestamp(String date,
      {String dateFormat = dateFormat, bool shortTimeStamp = false}) {
    try {
      DateTime dateTime = DateFormat(dateFormat).parse(date);
      if(shortTimeStamp == true) {
        return dateTime.millisecondsSinceEpoch ~/ 1000;
      }
      return dateTime.millisecondsSinceEpoch;
    } catch (ex) {
      return null;
    }
  }

  static String todayDate({String dateFormat = dateFormat}) {
    return DateFormat(dateFormat).format(DateTime.now());
  }

  static String formatTimeDifference(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds == 1) {
      return Label.secondAgo.trParams({'number': difference.inSeconds.toString()});
    } else if (difference.inSeconds < 60) {
      return Label.secondAgo.trParams({'number': difference.inSeconds.toString()});
    } else if (difference.inMinutes == 1) {
      return Label.minuteAgo.trParams({'number': difference.inMinutes.toString()});
    } else if (difference.inMinutes < 60) {
      return Label.minuteAgo.trParams({'number': difference.inMinutes.toString()});
    } else if (difference.inHours == 1) {
      return Label.hourAgo.trParams({'number': difference.inHours.toString()});
    } else if (difference.inHours < 24) {
      return Label.hourAgo.trParams({'number': difference.inHours.toString()});
    } else if (difference.inDays == 1) {
      return Label.dayAgo.trParams({'number': difference.inDays.toString()});
    } else if (difference.inDays <= 7) {
      return Label.dayAgo.trParams({'number': difference.inDays.toString()});
    } else {
      return DateFormat('dd/MM/yyyy hh:mm aa').format(dateTime);
    }
  }

  DateTime setTimeToMidnight(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  DateTime setTimeTo2359(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
  }

  String durationToString(Duration duration, {String delimiter = ''}) {
    return [duration.inHours, duration.inMinutes, duration.inSeconds].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(delimiter);
  }

  static bool stringDateIsToday(String dateString) {
    if (dateString.isEmpty) return false;
    try {
      return DateTime.parse(dateString).isToday;
    } catch (e) {
      return false;
    }
  }

  bool isTodayBirthday(String dateString) {
    if (dateString.isEmpty) return false;
    try{
      DateTime birthday = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      return now.month == birthday.month && now.day == birthday.day;
    } catch (e) {
      return false;
    }
  }

  static String timestampToString(int? ts, {String dateFormat = dateFormat}) {
    if(ts == null) {
      return '';
    }
    return DateManager.formatDateToString(
      DateTime.fromMillisecondsSinceEpoch(ts * 1000),
      dateFormat: dateFormat,
    );
  }

  bool areDatesDifferent(DateTime timestamp1, DateTime timestamp2) {
    return timestamp1.year != timestamp2.year ||
        timestamp1.month != timestamp2.month ||
        timestamp1.day != timestamp2.day;
  }

  static bool checkIsBefore(String? date, {String dateFormat = dateFormat, Duration subtractDuration = Duration.zero}) {
    if (date?.isEmpty == true) return false;
    DateTime? dateTime = formatStringToDate(date!, dateFormat: dateFormat);
    if(dateTime != null) {
      if(DateTime.now().isBefore(dateTime.subtract(subtractDuration)) == true) {
        return true;
      }
    }
    return false;
  }

}
