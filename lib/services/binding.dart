import 'package:get/get.dart';
import 'package:nsutz/controller/captcha_controller.dart';
import 'package:nsutz/controller/dashboard_controller.dart';
import 'package:nsutz/controller/datewiseattn_controller.dart';
import 'package:nsutz/controller/login_controller.dart';
import 'package:nsutz/controller/notice_controller.dart';
import 'package:nsutz/controller/splash_controller.dart';
import 'package:nsutz/controller/studentprofile_controller.dart';
import 'package:nsutz/controller/subjectwiseattn_controller.dart';
import 'package:nsutz/services/attendance_service.dart';
import 'package:nsutz/services/connection_check_service.dart';
import 'package:nsutz/services/hive_service.dart';
import 'package:nsutz/services/ml_service.dart';
import 'package:nsutz/services/nsutapi.dart';
import 'package:nsutz/services/session_service.dart';
import 'package:nsutz/services/shared_pref.dart';
import 'package:nsutz/services/studentprofile_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    //services

    //lazyput now working unknown reason
    //fenix true: make the class singleton and will not get destoryed after the page is poped or deleted
    // Get.lazyPut(() => NsutApi(), fenix: false);
    // Get.lazyPut(() => SharedPrefs(), fenix: false);
    // Get.lazyPut(() => CreditionalSerivce(), fenix: false);
    // Get.lazyPut(() => SessionSerivce(), fenix: false);
    // Get.lazyPut(() => StudentProfileSerivce(), fenix: false);
    // Get.lazyPut(() => AttendanceSerivce(), fenix: false);

    //core services
    Get.put(NsutApi(), permanent: true);
    Get.put(HiveService(), permanent: true);
    Get.put(SharedPrefs(), permanent: true);
    Get.put(CaptchaMlService(), permanent: true);
    Get.put(NetworkConnectivityService(), permanent: true);
    Get.put(SessionSerivce(), permanent: true);
    Get.put(StudentProfileSerivce(), permanent: true);
    Get.put(AttendanceSerivce(), permanent: true);
  }
}

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}

class CaptchaBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CaptchaController());
  }
}

class DatewiseAttnBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DatewiseAttnController());
  }
}

class SubjectWiseAttnBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubjectWiseAttnController());
  }
}

class StudentProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StudentProfileCotnroller());
  }
}

class NoticeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NoticeController());
  }
}
