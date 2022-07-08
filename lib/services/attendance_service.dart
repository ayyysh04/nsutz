//Stores attendance related data and attendance fetching services
import 'package:get/get.dart';
import 'package:nsutz/model/attendance_model.dart';
import 'package:nsutz/services/nsutapi.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class AttendanceSerivce {
  List<AttendanceModelSubWise> attendanceData = [];
  final SessionSerivce _sessionService = Get.find<SessionSerivce>();
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();

//api service
  final NsutApi _nsutApi = Get.find<NsutApi>();

  Future<String?> getAttendanceData() async {
    var res = await _nsutApi.getAttendanceData(
        _sessionService.sessionData.activities!,
        _studentProfileSerivce.studentData.studentID!,
        _studentProfileSerivce.studentData.studentDegree!,
        _studentProfileSerivce.studentData.studentDegree!);

    if (res.error != null || res.data == null) return res.error;

    String semNo = res.data!["semNo"];
    _studentProfileSerivce.studentData.studentCurrentSemester =
        int.parse(semNo);

    attendanceData = res.data!["attnData"];
    return null;
  }

  void resetAttenanceData() {
    attendanceData = [];
  }
}
