import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nsutz/model/attendance_model.dart';
import 'package:nsutz/services/attendance_service.dart';
import 'package:nsutz/theme/constants.dart';

//TODO: implemntation

class DatewiseAttnController extends GetxController {
  //serives
  final AttendanceSerivce _attendanceSerivce = Get.find<AttendanceSerivce>();

  @override
  void onInit() {
    setDateWiseAttn();
    super.onInit();
  }

  bool isSearchOn = false;
  List<AttendanceModelDateWise> datewiseAttnData = [];
  // List subjects = [];
  setDateWiseAttn() {
    var subAttnData = _attendanceSerivce.attendanceData;
    for (var i = 0;
        subAttnData[0].details != null && i < subAttnData[0].details!.length;
        i++) //no of days
    {
      List<Map<String, String>> subWiseData = [];
      for (var j = 0; j < subAttnData.length; j++) {
        subWiseData.add({
          subAttnData[j].subjectName!: subAttnData[j].details![i].values.first
        });
      }
      datewiseAttnData.add(AttendanceModelDateWise(
          date: subAttnData[0].details![i].keys.first, subData: subWiseData));
    }
  }

  List<AttendanceModelDateWise> searchAttnData = [];
  Future<String> getStudentAttendance() async {
    if (_attendanceSerivce.attendanceData.isEmpty) {
      var res = await _attendanceSerivce.getAttendanceData();

      setDateWiseAttn();
      if (res == null) {
        return "success";
      }

      return res;
    }
    return "success";
  }

  //data wise utils/servies
  void search(DateTime date, BuildContext context) {
    //Attendance of particular date finder

    isSearchOn = true;
    searchAttnData = [];
    //converting system date format to database format date
    String month = shortMonths[date.month];
    int currdate = date.day;
    String day = (currdate < 10)
        ? ("0" + date.day.toString())
        : date.day.toString(); //adding 0 when a single digit day comes
    String year = date.year.toString();
    // String finalDate = '$day $month $year';//TODO:FORMAT THE PROPER DATE OF ATTNDATA IN API
    String finalDate = '$month-$day';

    //finding date in attnData

    for (var i in datewiseAttnData) {
      if (i.date == finalDate) {
        searchAttnData.add(i);
        break;
      }
    }

    update();
  }

  void resetSearch() {
    _attendanceSerivce.attendanceData = [];
    update();
  }

  void reverseAttnDateWise() {
    datewiseAttnData = List.from(datewiseAttnData.reversed);
    update();
  }

  Future<bool> backButtonCallBack() async {
    if (isSearchOn == false) {
      return true;
    } else {
      isSearchOn = false;
      searchAttnData = [];
      update();
      return false;
    }
  }
}
