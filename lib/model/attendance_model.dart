class AttendanceModelSubWise {
  String? subjectCode;
  String? overallPresent;
  String? overallAbsent;
  String? overallClasses;
  double? overallPercentage;
  String? subjectName;

  List<Map<String, String>>? details;
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

//-------------DATEWISE MODEL-------------
class AttendanceModelDateWise {
  String date;
  List<Map<String, String>> subData;
  AttendanceModelDateWise({
    required this.date,
    required this.subData,
  });
}
