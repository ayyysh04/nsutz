import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

const kLightgreen = Color(0xFF00E6AD);
const kLightred = Color(0xFFFF606F);
const kLightYellow = Color(0xFFDCA05F);
const kLightblue = Color(0xFF3F5B91);
const kCardbackgroundcolor = Color(0x60758AA7);
const kBackgroundcolor = Color(0xFF212D49);

const List<String> weekdays = [
  ' ',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];
const List<String> months = [
  ' ',
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

final kColumnTextStyleLarge = TextStyle(
  fontFamily: 'Questrial',
  fontSize: 90.sp,
  fontWeight: FontWeight.bold,
);

final kColumnTextStyleSmall = TextStyle(
  fontFamily: 'Questrial',
  fontSize: 40.sp,
);

final kColumnTextStyleMedium = TextStyle(
  fontFamily: 'Questrial',
  fontSize: 60.sp,
);

final List shortMonths = [
  ' ',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String toStringDate(DateTime date) //'04 02 2020' to '04 july 2020 \nMonday'
{
  DateFormat format = DateFormat("dd MMMM yyyy \nEEEE");
  return format.format(date);
}

TextStyle textStyle(context, {double? fontSize, FontWeight? fontWeight}) {
  return TextStyle(
      fontFamily: 'Questrial', fontSize: fontSize, fontWeight: fontWeight);
}
