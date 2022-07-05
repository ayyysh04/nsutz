import 'package:get/get.dart';
import 'package:nsutz/model/attendance_model.dart';
import 'package:nsutz/services/attendance_service.dart';

class SubjectWiseAttnController extends GetxController {
  AttendanceModel subAttnData = AttendanceModel();

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
        return "success";
      }

      return res;
    }
    subAttnData = getSubAttnData(subjectName);
    return "success";
  }

  AttendanceModel getSubAttnData(String subjectName) {
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

  // TODO implement this logic
  String getAttnMarkString(String attnMarkString) {
    // if(attnMarkString == "CS")
    return '';
  }
}
