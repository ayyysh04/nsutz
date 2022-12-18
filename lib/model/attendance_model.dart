class AttendanceModelSubWise {
  String? subjectCode;
  int? overallPresent;
  int? overallAbsent;
  int? overallClasses;
  double? overallPercentage;
  String? subjectName;

  List<Map<DateTime, String>>? details;
  //date:attnMark
  AttendanceModelSubWise({
    this.subjectName,
    this.subjectCode,
    this.overallPresent,
    this.overallAbsent,
    this.overallClasses,
    this.overallPercentage,
    this.details,
  });
}

String? getMonthName(String enncodedDate) {
  String endcodedMonth = enncodedDate.split("-")[0];
  String? month;

  if (endcodedMonth == "Dec") {
    month = "December";
  } else if (endcodedMonth == "Nov") {
    month = "November";
  } else if (endcodedMonth == "Oct") {
    month = "October";
  } else if (endcodedMonth == "Sep") {
    month = "September";
  } else if (endcodedMonth == "Aug") {
    month = "August";
  } else if (endcodedMonth == "Jul") {
    month = "July";
  } else if (endcodedMonth == "Jun") {
    month = "June";
  } else if (endcodedMonth == "May") {
    month = "May";
  } else if (endcodedMonth == "Apr") {
    month = "Apr";
  } else if (endcodedMonth == "Mar") {
    month = "March";
  } else if (endcodedMonth == "Feb") {
    month = "Feburary";
  } else if (endcodedMonth == "Jan") {
    month = "January";
  }

  return month;
}

DateTime toDate(String enncodedDate, String year) //Jul-09
{
  var endcodedSplit = enncodedDate.split("-");
  String endcodedMonth = endcodedSplit[0];
  String day = endcodedSplit[1];
  String? month;

  if (endcodedMonth == "Dec") {
    month = "12";
  } else if (endcodedMonth == "Nov") {
    month = "11";
  } else if (endcodedMonth == "Oct") {
    month = "10";
  } else if (endcodedMonth == "Sep") {
    month = "09";
  } else if (endcodedMonth == "Aug") {
    month = "08";
  } else if (endcodedMonth == "Jul") {
    month = "07";
  } else if (endcodedMonth == "Jun") {
    month = "06";
  } else if (endcodedMonth == "May") {
    month = "05";
  } else if (endcodedMonth == "Apr") {
    month = "04";
  } else if (endcodedMonth == "Mar") {
    month = "03";
  } else if (endcodedMonth == "Feb") {
    month = "02";
  } else if (endcodedMonth == "Jan") {
    month = "01";
  }

  return DateTime.parse("$year-${month!}-$day"); //"2012-02-27"
}

//-------------DATEWISE MODEL-------------
class AttendanceModelDateWise {
  DateTime date;
  List<Map<String, String>> subData;
  //subject:attnMark
  AttendanceModelDateWise({
    required this.date,
    required this.subData,
  });
}
