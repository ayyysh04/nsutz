import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nsutz/model/attendance_model.dart';
import 'package:nsutz/services/attendance_service.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:nsutz/view/widgets/attn_symbols/attn_symbols.dart';

class SubjectWiseAttnController extends GetxController {
  AttendanceModelSubWise subAttnData = AttendanceModelSubWise();

  //services
  final AttendanceSerivce _attendanceSerivce = Get.find<AttendanceSerivce>();
  Future<void> onRefreshAttendance() async {
    _attendanceSerivce.attendanceData.clear();
  }

  void refreshAttnData() async {
    _attendanceSerivce.attendanceData.clear();
    update();
  }

  Future<String> getStudentAttendance(String subjectName) async {
    if (_attendanceSerivce.attendanceData.isEmpty) {
      var res = await _attendanceSerivce.getAttendanceData();

      if (res == null) {
        //TODO:use better return statement for proper management like here using null as success is a bad practice
        subAttnData = getSubAttnData(subjectName);
        return "success";
      }

      return res;
    }

    subAttnData = getSubAttnData(subjectName);
    return "success";
  }

  AttendanceModelSubWise getSubAttnData(String subjectName) {
    return _attendanceSerivce.attendanceData
        .firstWhere((element) => element.subjectCode == subjectName);
  }

  bool? getIsPresent(String attnMarkString) {
    if (attnMarkString == '0') {
      return false;
    } else if (attnMarkString == '1' || attnMarkString == '2') {
      return true;
    } else if (attnMarkString == '') {
      return null;
    }

    return null;
  }

  dynamic getAttendanceIcon(String attnMarkString) {
    if (attnMarkString == '0') {
      return Icon(
        Icons.close,
        color: kLightred,
        size: 110.w,
      );
    } else if (attnMarkString == '1') {
      return Icon(
        Icons.check,
        color: kLightgreen,
        size: 110.w,
      );
    } else if (attnMarkString == '1+1') {
      return Row(
        children: [
          Icon(
            Icons.check,
            color: kLightgreen,
            size: 110.w,
          ),
          Icon(
            Icons.check,
            color: kLightgreen,
            size: 110.w,
          ),
        ],
      );
    } else {
      return InitialsTextSymbol(attnMark: attnMarkString);
    }
  }

  final Map<String, String> attnMarkEquivalent = {
    'NM': 'Attendance Not Marked',
    "CR": "Class Rescheduled",
    "CS": "Class Suspended",
    "GH": "Gazetted Holiday",
    "MB": "Mass Bunk",
    "MS": "Mid Sem Exam",
    "NA": "Timetable Not Allotted",
    "NT": "Class Not Taken",
    "OD": "Teacher on Official duty",
    "TL": "Teacher on Leave",
    "1+1": "double present",
    "1": "present",
    "0": "absent"
  };

  String getTooltipMsg(String attnMarkString) {
    return attnMarkEquivalent[attnMarkString] ?? attnMarkString;
  }
}
