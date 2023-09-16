// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:get/get.dart';

import 'package:nsutz/model/attendance_model.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/attendance_service.dart';
import 'package:nsutz/services/connection_check_service.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class DashboardController extends GetxController {
  //services
  final StudentProfileSerivce _profileSerivce =
      Get.find<StudentProfileSerivce>();
  final AttendanceSerivce _attendanceSerivce = Get.find<AttendanceSerivce>();
  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();

  //network services
  final NetworkConnectivityService networkConnectivityService =
      Get.find<NetworkConnectivityService>();
  //functions
  @override
  void onInit() {
    networkConnectivityService.connectionStream.listen((source) async {
      printInfo(info: networkConnectivityService.isOnline.toString());
      if (networkConnectivityService.isOnline &&
          !_sessionSerivce.isSessionUpdated) {
        var res = await _sessionSerivce.loadSessionData();

        if (res == true) {
          networkConnectivityService.rebuildConnectionStatusBar();
          update();
        }
      }
    });
    super.onInit();
  }

  bool get isSessionUpdated => _sessionSerivce.sessionData.dashboard != null;

//TODO: remove attnDat getter ,make seprate function for length ,and to retrive a particular item rather giving whole data
  List<AttendanceModelSubWise> get attnData =>
      _attendanceSerivce.attendanceData;

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
    if (networkConnectivityService.isOnline) {
      attnData.clear();
    }
    update();
  }

  Future<bool> getStudentAttendance() async {
    if (_attendanceSerivce.attendanceData.isEmpty) {
      var res = await _attendanceSerivce.getAttendanceData();
      if (res != Result.success) {
        return false;
        // return res.toString(); TODO: SHOW SNACKBAR OR SOMETHING
      }
    }
    return true;
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

  void openSubDayWise(
      {required String subName,
      required double overallPer,
      required String subCode}) {
    Get.toNamed(Routes.SUBWISEATTN,
        arguments: {"subName": subName, "subCode": subCode});
  }

  void openStuentProfile() {
    Get.toNamed(Routes.STUPROFILE);
  }

  ///update session data and load new attendance data
  Future<void> loadAttendanceDataRomServer() async {
    var check = await _sessionSerivce.startSessionAndCheckLogin();
    printInfo(info: check.toString());
    if (check == Result.success) {
      var stuProfileRes = await _profileSerivce.getStudentProfileData();
      if (stuProfileRes == Result.success) {
        // Get.offNamed(Routes.DASHBOARD);
      }
      // else TODO:network error case : show snackbar or something else

    } else if (check == Result.invalidData) {
      // Get.offNamed(Routes.LOGIN);
    } else if (check == Result.invalidSession) {
      //start new session , as prev session is expired now
      // Get.offNamed(Routes.CAPTCHA);
    } else if (check ==
        Result
            .networkError) //TODO:network error ,show snackbar or something else
    {
      printError(info: check.toString());
      // Get.offNamed(Routes.DASHBOARD);
    } else {
      printError(info: Result.internalError.toString());
    }
  }

  Future<bool> onExit() async {
    await _attendanceSerivce.saveStudentProfileData();
    await _profileSerivce.saveStudentProfileData();
    return true;
  }
}
