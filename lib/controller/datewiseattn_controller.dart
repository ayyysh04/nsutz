import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/services/attendance_service.dart';
import 'package:nsutz/theme/constants.dart';

//TODO: implemntation
class DatewiseAttnController extends GetxController {
  //serives
  final AttendanceSerivce _attendanceSerivce = Get.find<AttendanceSerivce>();

  //functions
  // get subAttnData => _attendanceSerivce.attendanceData;
  List attnData = [
    {
      'date': "25 Jun 2022",
      "attn": [
        {'Os': 'P'},
        {'DSA': 'P'},
        {'CP': 'A'}
      ]
    },
    {
      'date': "26 Jun 2022",
      "attn": [
        {'Os': 'P'},
        {'DSA': 'A'},
        {'CP': 'P'}
      ]
    }
  ];

  List tempAttnData = [];

  //data wise utils/servies
  void search(DateTime date, BuildContext context) {
    //Attendance of particular date finder

    //converting system date format to database format date
    String month = shortMonths[date.month];
    int currdate = date.day;
    String day = (currdate < 10)
        ? ("0" + date.day.toString())
        : date.day.toString(); //adding 0 when a single digit day comes
    String year = date.year.toString();
    String finalDate = '$day $month $year';
    // print(finalDate);

    //finding date in attnData
    List searchAttnData = [];
    bool isFound = false;
    for (var i in attnData) {
      if (i['date'] == finalDate) {
        isFound = true;
        searchAttnData.add(i);
        break;
      }
    }
    if (isFound) {
      tempAttnData = attnData;
      attnData = searchAttnData;
      update();
    }
    if (!isFound) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Date not Found'),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ))
              ],
            );
          });
    }
  }

  void resetSearch() {
    if (tempAttnData.isEmpty) return;

    attnData = tempAttnData;
    tempAttnData = [];
    update();
  }

  void reverseAttnDateWise() {
    attnData = List.from(attnData.reversed);
    update();
  }

  Future<bool> backButtonCallBack() async {
    if (tempAttnData.isEmpty) {
      return true;
    } else {
      attnData = tempAttnData;
      tempAttnData = [];
      update();
      return false;
    }
  }
}
