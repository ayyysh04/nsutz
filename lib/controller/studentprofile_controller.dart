import 'package:get/get.dart';
import 'package:nsutz/model/student_model.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class StudentProfileCotnroller extends GetxController {
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();

  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();

  Student get studentProfileData => _studentProfileSerivce.studentData;

  Future<void> logout() async {
    _sessionSerivce.logOut();
  }
}
