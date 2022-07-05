import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class LoginController extends GetxController {
  String? msg;
  bool showCollegeError = false;
  bool isLoading = false;
  String? captchaLink;
  FocusNode rollNoFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode captchaNoFocusNode = FocusNode();
  TextEditingController rollNoController =
      TextEditingController(text: "2020UEI2838");
  TextEditingController passController =
      TextEditingController(text: "jhjrjn?7");
  TextEditingController captchaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  //serivces
  final StudentProfileSerivce _studentProfileSerivce =
      Get.find<StudentProfileSerivce>();
  final SessionSerivce _sessionSerivce = Get.find<SessionSerivce>();

  Future<String?> getCaptcha() async {
    captchaLink ??= await _sessionSerivce.getCaptcha();
    return captchaLink;
  }

  //functions
  void reloadCaptcha() {
    captchaLink = null;
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

    var res = await _sessionSerivce.login(
        rollno: rollNoController.text,
        password: passController.text,
        captcha: captchaController.text);
    //save login id and pass  and other things in local storage
    //TODO: How to sync the local stored data with new data

    if (res == null &&
        await _studentProfileSerivce.getStudentProfileData() == null) {
      Get.offNamed(Routes.DASHBOARD);
    } else {
      isLoading = false;
      msg = res;
      // passController.clear();
      update();
    }
  }
}
