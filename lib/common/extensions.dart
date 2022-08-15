import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringX on String {
  Color hexToColor() =>
      Color(int.parse(substring(1, 7), radix: 16) + 0xFF000000);

  int toInt() => int.parse(this);

  Uri toUri() => Uri.parse(this);

  String toShortString() {
    return split('.').last.toLowerCase();
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  DateTime get fromTimeStamp {
    return DateTime.fromMillisecondsSinceEpoch(toInt() * 1000);
  }
}

extension IntX on num {
  String toStringAndFill({int length = 2, String value = '0'}) => toString().padLeft(length, value);

  String toNumberFormatCompact() => NumberFormat.compact().format(this);
}

extension DoubleX on double {
  double truncateToDecimals(int decimals) =>
      double.parse(toStringAsFixed(decimals));
}

extension DurationX on Duration {
  String toTimeFormattedString() {
    String twoDigitSeconds = inSeconds.remainder(60).toStringAndFill();
    String twoDigitMinutes = '${inMinutes.remainder(60).toStringAndFill()}:';
    String twoDigitHours = inHours == 0 ? '' : '${inHours.toStringAndFill()}:';

    String finalStr = '$twoDigitHours$twoDigitMinutes$twoDigitSeconds';
    return finalStr;
  }
}

extension DateTimeX on DateTime {
  int get toTimeStamp => millisecondsSinceEpoch ~/ 1000;
}