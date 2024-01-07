import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class LoginController extends GetxController {
  String? msg;
  bool isLoading = false;
  Image? captchaImg;
  FocusNode rollNoFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode captchaNoFocusNode = FocusNode();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController captchaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  //serivces
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();
  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();
  Future<Image?> getCaptcha() async {
    // await _sessionSerivce.startSessionService();
    if (captchaImg == null) {
      var capRes = await _sessionSerivce.getCaptcha();

      if (capRes.res != Result.success) {
        printError(info: capRes.res.toString());
        return null;
        // TODO:show snackbar of error
      }

      captchaImg = Image.memory(capRes.data!.captchaUInt8!);

      //TODO:ML captcha test
      if (capRes.data!.captchaText != null) {
        captchaController.text = capRes.data!.captchaText!;
      }
    }
    return captchaImg;
  }

  //functions
  void reloadCaptcha() {
    captchaImg = null;
    captchaController.clear();
    update();
  }

  void login() async {
    if (isLoading == true) //no more calls when already loading
    {
      return null;
    }
    isLoading = true;
    update();

    var loginRes = await _sessionSerivce.login(
        rollno: rollNoController.text,
        password: passController.text,
        captcha: captchaController.text);
    //save login id and pass  and other things in local storage
    //TODO: NEW UPDATE : How to sync the local stored data with new data : using cachehttpManager

    if (loginRes == Result.success &&
        await _studentProfileSerivce.getStudentProfileData() ==
            Result.success) {
      Get.offNamed(Routes.DASHBOARD);
    } else {
      if (loginRes == Result.invalidSession) {
        msg = "Wrong rollno / password";
        await _sessionSerivce.startSessionService();
        reloadCaptcha();
      } else if (loginRes == Result.invalidCaptcha) {
        msg = "Wrong Captcha";
      }

      isLoading = false;
      // TODO : testing -> passController.clear();
      update();
    }
  }
}
