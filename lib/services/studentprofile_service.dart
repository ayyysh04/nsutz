//Stores profile related data and profile fetching services
import 'dart:developer';

import 'package:get/get.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/model/student_model.dart';
import 'package:nsutz/services/hive_service.dart';
import 'package:nsutz/services/nsutapi.dart';
import 'package:nsutz/services/session_service.dart';

class StudentProfileSerivce {
  Student studentData = Student();
  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();

//api service
  final NsutApi _nsutApi = Get.find<NsutApi>();
  final HiveService _hiveService = Get.find<HiveService>();

  ///result : success , invalidPassword,invalidCaptcha , NetworkError
  Future<Result> getStudentProfileData() async {
    //TODO : CHECK THIS TOO FOR SESSION UPDATED KEY
    if (_sessionSerivce.sessionData.dashboard != null) {
      var stuProfilefres = await _nsutApi.getStudentProfile(
        _sessionSerivce.sessionData.dashboard!,
      );

      if (stuProfilefres.res != Result.success) return stuProfilefres.res;

      studentData = stuProfilefres.data!;
    }
    return Result.success;
  }

  Future<void> resetProfileData() async {
    studentData = Student();
    await _hiveService.profileDataBox!.clear();
  }

  Future<void> saveStudentProfileData() async {
    await _hiveService.profileDataBox!.put("profileData", studentData);
  }

  bool loadStudentProfileData() {
    if (_hiveService.profileDataBox!.containsKey("profileData")) {
      studentData = _hiveService.profileDataBox!.get("profileData")!;
      printInfo(info: "Prev profile data loaded from memory");
      return true;
    }

    return false;
  }
}
