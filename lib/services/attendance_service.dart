//Stores attendance related data and attendance fetching services
import 'package:get/get.dart';
import 'package:nsutz/model/attendance_model.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/services/nsutapi.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class AttendanceSerivce {
  //all the attendance data will be accessed using attendance model not by function returns
  List<AttendanceModelSubWise> attendanceData = [];
  final SessionSerivce _sessionService = Get.find<SessionSerivce>();
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();

//api service
  final NsutApi _nsutApi = Get.find<NsutApi>();

  ///Result : invalidSession ,networkError,Success
  Future<Result> getAttendanceData() async {
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
    return Result.success;
  }

  void resetAttenanceData() {
    attendanceData = [];
  }
}
