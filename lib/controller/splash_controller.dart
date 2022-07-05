import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/shared_pref.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class SplashController extends GetxController {
  final SharedPrefs _sharedPrefsService = Get.find<SharedPrefs>();
  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();

  Future<void> checkLoginAndNavigate() async {
    await _sharedPrefsService.init();
    var check = await _sessionSerivce.resumeLogin();

    if (check !=
        null) //TODO:remove isLogin and use rollNo and password as its replacement
    {
      if (check == true &&
          await _studentProfileSerivce.getStudentProfileData() == null) {
        Get.offNamed(Routes.DASHBOARD);
      } else {
        Get.offNamed(Routes.CAPTCHA);
      }
    } else {
      Get.offNamed(Routes.LOGIN);
    }
    FlutterNativeSplash.remove();
  }
}
