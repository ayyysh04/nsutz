//Stores session related data and session fetching services

import 'dart:developer';

import 'package:get/get.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/model/session_model.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/ml_service.dart';
import 'package:nsutz/services/nsutapi.dart';
import 'package:nsutz/services/shared_pref.dart';

class SessionSerivce {
//IMP:all session data should be accessed via modelData not by any function return
//core service
  final NsutApi _nsutApi = Get.find<NsutApi>();
  final SharedPrefs _sharedPrefsService = Get.find<SharedPrefs>();
  final CaptchaMlService _captchaMlService = Get.find<CaptchaMlService>();
//my services
  Session sessionData = Session();

  ///result : success , network error
  Future<Result> startSessionService({String? cookie}) async {
    var cookieRes = await _nsutApi.setCookieAndHeaders(cookieArg: cookie);
    sessionData.cookie = cookieRes.data;
    return cookieRes.res;
  }

  bool get isSessionUpdated =>
      sessionData.dashboard != null &&
      sessionData.activities != null &&
      sessionData.registration != null;

  ///result : NetworkError , success
  ///
  ///data : Uint8List? captchaUInt8, String? captchaText
  Future<CustomResponse<MLCaptchaResponse>> getCaptcha() async {
    var networdRes = await _nsutApi.getCaptcha();

    if (networdRes.res != Result.success) {
      return CustomResponse(res: networdRes.res);
    }

    //call ml service for recognation
    String? capCode =
        _captchaMlService.classify(networdRes.data!.captchaUInt8!);
    //TODO:if ml cannot recog capCode ,show bottombar to manually input the capCode

    sessionData.hrand = networdRes.data!.hrand!;
    return CustomResponse(
        res: Result.success,
        data: MLCaptchaResponse(
            captchaUInt8: networdRes.data!.captchaUInt8, captchaText: capCode));
  }

  ///Network error , success
  Future<CustomResponse<CaptchaResponse>> reloadCaptcha() async {
    return await _nsutApi.reloadCaptcha();
  }

  ///result : invalid session ,network error ,success ,invalidCaptcha
  Future<Result> login(
      {String? rollno, String? password, required String captcha}) async {
    if (rollno == null && password == null) //captcha login
    {
      rollno = sessionData.rollNo;
      password = sessionData.password;
    }
    var loginRes = await _nsutApi.loginUsingCaptcha(
        rollno!, password!, captcha, sessionData.hrand!);
    if (loginRes.res != Result.success) //retry
    {
      return loginRes.res;
    }

    var imsRes = await _nsutApi.getStudentImsUrls(loginRes.data!);
    //saving in session model
    sessionData.dashboard = imsRes.data!.dashboard;
    sessionData.activities = imsRes.data!.activities;
    sessionData.registration = imsRes.data!.registration;
    sessionData.logout = imsRes.data!.logout;
    sessionData.plumUrl = imsRes.data!.plumUrl;

    sessionData.rollNo = rollno;
    sessionData.password = password;

    //login success
    //save all data  locally
    _sharedPrefsService.rollNo = rollno;
    _sharedPrefsService.password = password;
    _sharedPrefsService.cookie = sessionData.cookie;
    _sharedPrefsService.plumUrl = sessionData.plumUrl;
    return Result.success;
  }

  ///start session and check if login is resuable or not -> if yes then loads the ims urls (dashboard ,profile ,etc)
  ///
  ///result : success , network error , invalidData , invalid session
  Future<Result> startSessionAndCheckLogin() async {
    var cookie = _sharedPrefsService.cookie;
    var plumUrl = _sharedPrefsService.plumUrl;

    // cookie = null; //TODO:only for captcha testing
    // rollNo = "2021UIT3132";
    // password = "Pankaj#1974";

    // print(isLogin);
    // print(cookie);
    // print(plumUrl);

    // if (rollNo != null && password != null) //already login
    // {
    sessionData.rollNo = _sharedPrefsService.rollNo;
    sessionData.password = _sharedPrefsService.password;
    if (cookie != null && plumUrl != null) //restore login session
    {
      printInfo(info: "session continued using cookie");
      await startSessionService(
          cookie:
              cookie); //set stored cookie : no need to check result as this is only seting prev cookie

      var stuImsres =
          await _nsutApi.getStudentImsUrls(plumUrl); //get the profile Ims links
      if (stuImsres.res == Result.success) {
        sessionData.plumUrl = stuImsres.data!.plumUrl;
        sessionData.dashboard = stuImsres.data!.dashboard;
        sessionData.activities = stuImsres.data!.activities;
        sessionData.registration = stuImsres.data!.registration;
        sessionData.logout = stuImsres.data!.logout;
        return Result.success; //login successfull
      } else if (stuImsres.res ==
          Result.invalidSession) //session expired !relogin using new captcha
      {
        //removed expired data
        _sharedPrefsService.cookie = null;
        _sharedPrefsService.plumUrl = null;
        return Result.invalidSession;
      } else {
        return Result.networkError;
      }
    }
    printInfo(info: "new session started");
    //without cookie -> starting new session for logined user
    await startSessionService();
    bool isLogin = false;
    while (isLogin != true) {
      var capRes = await getCaptcha();

      if (capRes.res != Result.success) {
        printError(info: capRes.res.toString());
        return capRes.res;
      }
      if (capRes.data!.captchaText != null) {
        var loginRes = await login(captcha: capRes.data!.captchaText!);
        isLogin = true;
      } else {
        reloadCaptcha();
      }
    }

    return Result.networkError;
  }

  //TODO:without cookie
  Future<bool> loadSessionData() async {
    var res = await startSessionService();
    if (res == Result.networkError) {
      return false;
    }
    while (true) {
      var capRes = await getCaptcha();
      if (capRes.res == Result.networkError) {
        return false;
      }
      if (capRes.data!.captchaText != null) {
        var res = await login(
            captcha: capRes.data!.captchaText!,
            password: _sharedPrefsService.password,
            rollno: _sharedPrefsService.rollNo);

        if (res == Result.networkError) {
          return false;
        } else if (res == Result.success) {
          break;
        }
      }
      await reloadCaptcha();
    }

    return true;
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
