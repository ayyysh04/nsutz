import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class CaptchaController extends GetxController {
  bool? isLoading;
  String? msg;
  Image? captchaImg;
  final formKey = GlobalKey<FormState>();
  TextEditingController captchaController = TextEditingController();

  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();

  Future<Image?> getCaptcha() async {
    // (await _sessionSerivce.getCaptcha())!["captcha"];
    if (captchaImg == null) {
      var capRes = await _sessionSerivce.getCaptcha();

      if (capRes.res != Result.success) {
        return null;
        // TODO:show snackbar of error
      }

      captchaImg = Image.memory(capRes.data!.captchaUInt8!);

      //TODO:ML captcha test
      if (capRes.data!.captchaText != null) {
        captchaController.text = capRes.data!.captchaText!;
      }
    }
    // login();
    return captchaImg;
  }

  //functions
  Future<void> reloadCaptcha() async {
    captchaImg = null;
    await _sessionSerivce.reloadCaptcha();
    captchaController.clear();
    update();
  }

  // result : success , invalidPassword,invalidCaptcha , NetworkError
  void login() async {
    if (isLoading == true) //no more calls when already loading
    {
      return null;
    }
    isLoading = true;
    update();

    var loginRes = await _sessionSerivce.login(captcha: captchaController.text);
    //save login id and pass  and other things in local storage
    //TODO: NEW UPDATE : How to sync the local stored data with new data : using cachehttpManager

    if (loginRes == Result.success &&
        await _studentProfileSerivce.getStudentProfileData() ==
            Result.success) {
      Get.offNamed(Routes.DASHBOARD);
    } else {
      isLoading = false;
      msg = loginRes.toString();
      // TODO : testing -> passController.clear();
      update();
    }
  }
}
