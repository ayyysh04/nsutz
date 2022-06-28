//Stores session related data and session fetching services

import 'package:get/get.dart';
import 'package:nsutz/model/credentials_model.dart';
import 'package:nsutz/model/session_model.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/creditional_service.dart';
import 'package:nsutz/services/nsutapi.dart';
import 'package:nsutz/services/shared_pref.dart';

class SessionSerivce {
//api service
  final NsutApi _nsutApi = Get.find<NsutApi>();
  final SharedPrefs _sharedPrefsService = Get.find<SharedPrefs>();
  final CreditionalSerivce _creditionalSerivce = Get.find<CreditionalSerivce>();

//my services
  Session sessionData = Session();

  Future<String?> startSessionService({String? cookie}) async {
    var res = await _nsutApi.setCookieAndHeaders(cookie: cookie);

    if (res.error != null || res.data == null) return res.error;

    sessionData.cookie = res.data;
    return "set";
  }

  Future<String?> getCaptcha() async {
    var res = await _nsutApi.getCaptcha();
    if (res.error != null || res.data == null) return res.error;

    sessionData.hrand = res.data!['hrand'];

    return res.data!['captcha'];
  }

  Future<String?> login(String rollno, String password, String captcha) async {
    var res = await _nsutApi.loginAndCheckCaptcha(
        rollno, password, captcha, sessionData.hrand!);
    if (res.error != null || res.data == null) //retry
    {
      return res.error;
    }

    //saving in session model
    sessionData.dashboard = res.data!["dashboard"]!;
    sessionData.activities = res.data!["activities"]!;
    sessionData.registration = res.data!["registration"]!;
    sessionData.logout = res.data!["logout"]!;
    sessionData.plumUrl = res.data!["plumUrl"]!;

    //saving in creds model
    _creditionalSerivce.rollNo = rollno;
    _creditionalSerivce.password = password;

    //login success
    //save all data  locally
    _sharedPrefsService.rollNo = rollno;
    _sharedPrefsService.password = password;
    _sharedPrefsService.isLogin = true;
    _sharedPrefsService.cookie = sessionData.cookie;
    _sharedPrefsService.plumUrl = sessionData.plumUrl;
    // print(_sharedPrefsService.cookie);
    // print(_sharedPrefsService.plumUrl);
    return null;
  }

  Future<bool?> resumeLogin() async {
    var isLogin = _sharedPrefsService.isLogin;
    var cookie = _sharedPrefsService.cookie;
    var plumUrl = _sharedPrefsService.plumUrl;
    // print(isLogin);
    // print(cookie);
    // print(plumUrl);
    if (isLogin &&
        cookie != null &&
        plumUrl !=
            null) //TODO:remove isLogin and use rollNo and password as its replacement
    {
      await startSessionService(cookie: cookie); //set stored cookie

      var res =
          await _nsutApi.getStudentImsUrls(plumUrl); //get the profile Ims links

      if (res.error != null || res.data == null) {
        //removed expired data
        _sharedPrefsService.cookie = null;
        _sharedPrefsService.plumUrl = null;

        return false; //session expired !relogin using new captcha
      } else {
        sessionData.plumUrl = res.data!["plumUrl"];
        sessionData.dashboard = res.data!["dashboard"];
        sessionData.activities = res.data!["activities"];
        sessionData.registration = res.data!["registration"];
        sessionData.logout = res.data!["logout"];
      }
      return true; //login successfull
    } else {
      return null; //no prev data !login
    }
  }

  void logOut() async {
    // var res = await _nsutApi.logout(sessionData.plumUrl!, sessionData.logout!);
    // _creditionalSerivce.credentialsData = Credentials();
    // _sharedPrefsService.cookie = null;
    // _sharedPrefsService.isLogin = false;
    // _sharedPrefsService.password = null;
    // _sharedPrefsService.plumUrl = null;

    Get.offAllNamed(Routes.LOGIN);
  }
}
