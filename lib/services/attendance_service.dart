//Stores attendance related data and attendance fetching services
import 'package:get/get.dart';
import 'package:nsutz/model/attendance_model.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/services/hive_service.dart';
import 'package:nsutz/services/nsutapi.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class AttendanceSerivce {
  //all the attendance data will be accessed using attendance model not by function returns
  List<AttendanceModelSubWise> attendanceData = [];
  final SessionSerivce _sessionService = Get.find<SessionSerivce>();
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();
  final HiveService _hiveService = Get.find<HiveService>();

//api service
  final NsutApi _nsutApi = Get.find<NsutApi>();

  ///Result : invalidSession ,networkError,Success
  Future<Result> getAttendanceData() async {
    //if plumurl == null : offline mode
    if (_sessionService.sessionData.activities != null) {
      var attnRes = await _nsutApi.getAttendanceData(
          _sessionService.sessionData.activities!,
          _studentProfileSerivce.studentData.studentID!,
          _studentProfileSerivce.studentData.studentDegree!,
          _studentProfileSerivce.studentData.studentDegree!);
      //TODO: here branch name is given as degree cross check IMP

      if (attnRes.res != Result.success) return attnRes.res;

      _studentProfileSerivce.studentData.studentCurrentSemester =
          attnRes.data!.semesterNo!;
      attendanceData = attnRes.data!.attnData!;
    }
    return Result.success;
  }

  Future<void> resetAttenanceData() async {
    attendanceData = [];
    await _hiveService.attnDataBox!.clear();
  }

  Future<void> saveStudentProfileData() async {
    await _hiveService.attnDataBox!.addAll(attendanceData);
  }

  void loadStudentAttendanceData() {
    // if (_hiveService.profileDataBox!.containsKey("attnData")) {
    if (_hiveService.attnDataBox!.isNotEmpty) {
      attendanceData = _hiveService.attnDataBox!.values.toList();
      printInfo(info: "Prev attn data loaded from memory");
    }

    // }
  }
}
