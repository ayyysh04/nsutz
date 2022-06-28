import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class LoginController extends GetxController {
  String? msg;
  bool collegeenabled = false;
  bool showCollegeError = false;
  bool? isLoading;
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

    var res = await _sessionSerivce.login(
        rollNoController.text, passController.text, captchaController.text);
    //save login id and pass  and other things in local storage
    //TODO: How to sync the local stored data with new data

    if (res == null &&
        await _studentProfileSerivce.getStudentProfileData() == null) {
      Get.offNamed(Routes.DASHBOARD);
    } else {
      isLoading = false;
      msg = res;
      passController.clear();
      captchaController.clear();
      update();
    }
  }
}
