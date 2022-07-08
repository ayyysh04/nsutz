import 'package:get/get.dart';
import 'package:nsutz/model/student_model.dart';
import 'package:nsutz/services/attendance_service.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentProfileCotnroller extends GetxController {
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();
  final AttendanceSerivce _attendanceSerivce = Get.find<AttendanceSerivce>();

  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();

  Future<void> openlinkedinProfile() async {
    Uri url = Uri.parse('https://www.linkedin.com/in/ayush-yadav-6a712421a/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Student get studentProfileData => _studentProfileSerivce.studentData;

  Future<void> logout() async {
    _attendanceSerivce.resetAttenanceData();
    _studentProfileSerivce.resetProfileData();
    _sessionSerivce.logOut();
  }
}
