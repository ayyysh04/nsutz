//Stores profile related data and profile fetching services
import 'package:get/get.dart';
import 'package:nsutz/model/student_model.dart';
import 'package:nsutz/services/nsutapi.dart';
import 'package:nsutz/services/session_service.dart';

class StudentProfileSerivce {
  Student studentData = Student();
  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();

//api service
  final NsutApi _nsutApi = Get.find<NsutApi>();
  Future<String?> getStudentProfileData() async {
    var res = await _nsutApi.getStudentProfile(
      _sessionSerivce.sessionData.dashboard!,
    );

    if (res.error != null || res.data == null) return res.error;
    studentData = res.data!;

    return null;
  }
}
