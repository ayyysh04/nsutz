import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class CaptchaController extends GetxController {
  bool? isLoading;
  String? msg;
  String? captchaLink;
  final formKey = GlobalKey<FormState>();
  TextEditingController captchaController = TextEditingController();

  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();

  Future<String?> getCaptcha() async {
    captchaLink ??= await _sessionSerivce.getCaptcha();
    return captchaLink;
  }

  //functions
  Future<void> reloadCaptcha() async {
    captchaLink = null;
    await _sessionSerivce.reloadCaptcha();
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

    // dynamic res = await Provider.of<LoginProvider>(context, listen: false)
    //     .login(_id.text, password, lnctu);//login http call

    var res = await _sessionSerivce.login(captcha: captchaController.text);

    //TODO: How to sync the local stored data with new data

    if (res == null) {
      var res2 = await _studentProfileSerivce.getStudentProfileData();
      if (res2 == null) {
        Get.offAllNamed(Routes.DASHBOARD);
        return;
      }
    }
    isLoading = false;
    msg = res;
    captchaController.clear();
    update();
  }
}
