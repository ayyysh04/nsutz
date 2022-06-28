import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/creditional_service.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class CaptchaController extends GetxController {
  bool? isLoading;
  String? msg;
  final formKey = GlobalKey<FormState>();
  TextEditingController captchaController = TextEditingController();

  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();
  final CreditionalSerivce _creditionalSerivce = Get.find<CreditionalSerivce>();
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();

  Future<String?> getCaptcha() async {
    await _sessionSerivce.startSessionService();
    return await _sessionSerivce.getCaptcha();
  }

  //functions
  void login() async {
    if (isLoading == true) //no more calls when already loading
    {
      return null;
    }
    isLoading = true;
    update();

    // dynamic res = await Provider.of<LoginProvider>(context, listen: false)
    //     .login(_id.text, password, lnctu);//login http call

    var res = await _sessionSerivce.login(_creditionalSerivce.rollNo!,
        _creditionalSerivce.password!, captchaController.text);

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
