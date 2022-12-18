import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/shared_pref.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class SplashController extends GetxController {
  // @override
  // void onInit() {
  //   FlutterNativeSplash.remove();
  //   super.onInit();
  // }

  final SharedPrefs _sharedPrefsService = Get.find<SharedPrefs>();
  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();

  //check login data and start session service
  Future<void> checkUserDataAndNavigate() async {
    await _sharedPrefsService.init();
    var check = await _sessionSerivce.startSessionAndCheckLogin();

    if (check ==
        Result
            .success) //resumed the login success //TODO:remove isLogin and use rollNo and password as its replacement
    {
      var stuProfileRes = await _studentProfileSerivce.getStudentProfileData();
      if (stuProfileRes == Result.success) {
        Get.offNamed(Routes.DASHBOARD);
      }
      // else TODO:network error case : show snackbar or something else

    } else if (check == Result.invalidData) {
      Get.offNamed(Routes.LOGIN);
    } else if (check == Result.invalidSession) {
      //start new session , as prev session is expired now
      Get.offNamed(Routes.CAPTCHA);
    } else //TODO:network error ,show snackbar or something else
    {
      printError(info: check.toString());
    }
  }
}
