import 'package:get/get.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/attendance_service.dart';
import 'package:nsutz/services/connection_check_service.dart';
import 'package:nsutz/services/hive_service.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/shared_pref.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class SplashController extends GetxController {
  final SharedPrefs _sharedPrefsService = Get.find<SharedPrefs>();
  final HiveService _hiveService = Get.find<HiveService>();
  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();
  final AttendanceSerivce _attendanceSerivce = Get.find<AttendanceSerivce>();
  final NetworkConnectivityService _connectivityService =
      Get.find<NetworkConnectivityService>();
  //check login data and start session service
  Future<void> checkUserDataAndNavigate() async {
    await _hiveService.init();
    await _sharedPrefsService.init();
    await _connectivityService.initialise();
    if (_studentProfileSerivce.loadStudentProfileData()) //load login user data
    {
      _attendanceSerivce.loadStudentAttendanceData();
      Get.offNamed(Routes.DASHBOARD);
    } else //no data , fetch from internet
    {
      await _sessionSerivce.startSessionService();
      Get.offNamed(Routes.LOGIN);
    }
  }
}
