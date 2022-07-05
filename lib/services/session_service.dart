//Stores session related data and session fetching services

import 'package:get/get.dart';
import 'package:nsutz/model/session_model.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/nsutapi.dart';
import 'package:nsutz/services/shared_pref.dart';

class SessionSerivce {
//core service
  final NsutApi _nsutApi = Get.find<NsutApi>();
  final SharedPrefs _sharedPrefsService = Get.find<SharedPrefs>();

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

  Future<String?> login(
      {String? rollno, String? password, required String captcha}) async {
    if (rollno == null && password == null) //captcha login
    {
      rollno = sessionData.rollNo;
      password = sessionData.password;
    }
    var res = await _nsutApi.loginAndCheckCaptcha(
        rollno!, password!, captcha, sessionData.hrand!);
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

    sessionData.rollNo = rollno;
    sessionData.password = password;

    //login success
    //save all data  locally
    _sharedPrefsService.rollNo = rollno;
    _sharedPrefsService.password = password;
    _sharedPrefsService.cookie = sessionData.cookie;
    _sharedPrefsService.plumUrl = sessionData.plumUrl;

    return null;
  }

  Future<bool?> resumeLogin() async {
    /*
    null->relogin using id and pass
    true->resume success
    false->relogin using captcha
    */
    var cookie = _sharedPrefsService.cookie;
    var plumUrl = _sharedPrefsService.plumUrl;
    var rollNo = _sharedPrefsService.rollNo;
    var password = _sharedPrefsService.password;
    // print(isLogin);
    // print(cookie);
    // print(plumUrl);
    if (rollNo != null && password != null) //already login
    {
      sessionData.rollNo = _sharedPrefsService.rollNo;
      sessionData.password = _sharedPrefsService.password;
      if (cookie != null && plumUrl != null) //restore login session
      {
        await startSessionService(cookie: cookie); //set stored cookie

        var res = await _nsutApi
            .getStudentImsUrls(plumUrl); //get the profile Ims links

        if (res.error != null ||
            res.data == null) //session expired !relogin using new captcha
        {
          //removed expired data
          _sharedPrefsService.cookie = null;
          _sharedPrefsService.plumUrl = null;

          return false;
        } else {
          sessionData.plumUrl = res.data!["plumUrl"];
          sessionData.dashboard = res.data!["dashboard"];
          sessionData.activities = res.data!["activities"];
          sessionData.registration = res.data!["registration"];
          sessionData.logout = res.data!["logout"];
          return true; //login successfull
        }
      } else //no prev session,start a new one with saved roll no and captcha
      {
        await startSessionService();
        return false;
      }
    }
    //else no prev data login -> relogin
    await startSessionService();
    return null;
  }

  void logOut() async {
    // var res = await _nsutApi.logout(sessionData.plumUrl!, sessionData.logout!);
    resetSessionData();
    _sharedPrefsService.resetLocalStorage();
    Get.offAllNamed(Routes.SPLASH);
  }

  void resetSessionData() {
    sessionData = Session();
  }
}
