import 'package:intl/intl.dart';

String dobToString(DateTime date) {
  DateFormat format = DateFormat("dd MMMM yyyy");
  var formattedDate = format.format(date);
  return formattedDate;
}
