//Stores profile related data and profile fetching services
import 'package:get/get.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/model/student_model.dart';
import 'package:nsutz/services/nsutapi.dart';
import 'package:nsutz/services/session_service.dart';

class StudentProfileSerivce {
  Student studentData = Student();
  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();

//api service
  final NsutApi _nsutApi = Get.find<NsutApi>();

  ///result : success , invalidPassword,invalidCaptcha , NetworkError
  Future<Result> getStudentProfileData() async {
    var stuProfilefres = await _nsutApi.getStudentProfile(
      _sessionSerivce.sessionData.dashboard!,
    );

    if (stuProfilefres.res != Result.success) return stuProfilefres.res;

    studentData = stuProfilefres.data!;
    return Result.success;
  }

  void resetProfileData() {
    studentData = Student();
  }
}
