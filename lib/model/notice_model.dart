import 'package:intl/intl.dart';

class NoticeModel {
  String notice;
  String? url;
  DateTime date;
  String publishedBy;
  NoticeModel({
    required this.notice,
    this.url,
    required this.date,
    required this.publishedBy,
  });

  static DateTime toDate(
      String date) //DATE STRING SHOULD BE IN dd-MM-yyyy FORMAT
  {
    DateFormat formater = DateFormat('dd-MM-yyyy');
    return formater.parse(date);
  }
}
