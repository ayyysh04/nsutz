// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:get/get.dart';

import 'package:nsutz/model/attendance_model.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/attendance_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class DashboardController extends GetxController {
  //services
  final StudentProfileSerivce _profileSerivce =
      Get.find<StudentProfileSerivce>();

  final AttendanceSerivce _attendanceSerivce = Get.find<AttendanceSerivce>();

  //functions

//TODO: remove attnDat getter ,make seprate function for length ,and to retrive a particular item rather giving whole data
  List<AttendanceModel> get attnData => _attendanceSerivce.attendanceData;

  String getGreetingName() {
    return _profileSerivce.studentData.studentName!;
  }

  String getsuperscript(int n) {
    if (n == 1 || n == 21)
      return 'st';
    else if (n == 2 || n == 22)
      return 'nd';
    else if (n == 3 || n == 23)
      return 'rd';
    else
      return 'th';
  }

  void refreshAttnData() async {
    attnData.clear();
    update();
  }

  Future<String> getStudentAttendance() async {
    if (_attendanceSerivce.attendanceData.isEmpty) {
      var res = await _attendanceSerivce.getAttendanceData();

      if (res == null) {
        return "success";
      }

      return res;
    }
    return "success";
  }

  void openDateWisePage() {
    Get.toNamed(
      Routes.DATEWISEATTN,
    );
    // Navigator.push(
    //   context,
    //   PageRouteBuilder(
    //     pageBuilder: (context, animation1, animation2) =>
    //         DateWise(),
    //     transitionDuration: Duration(seconds: 0),
    //   ),
    // );
  }

  void openSubdayWise(
      {required String subName,
      required double overallPer,
      required String subCode}) {
    Get.toNamed(Routes.SUBWISEATTN,
        arguments: {"subName": subName, "subCode": subCode});
  }

  void openStuentProfile() {
    Get.toNamed(Routes.STUPROFILE);
  }
}
