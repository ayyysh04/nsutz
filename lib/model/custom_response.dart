import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:nsutz/model/attendance_model.dart';

class CustomResponse<T> //custom response
{
  T? data;
  Result res;

  ///return data and Result
  CustomResponse({this.data, required this.res});
}

enum Result {
  networkError,
  success,
  internalError,
  invalidData,
  invalidCaptcha,
  invalidSession,
  invalidPassword
}

class CaptchaResponse {
  String? hrand;
  Uint8List? captchaUInt8;
  CaptchaResponse({
    this.hrand,
    this.captchaUInt8,
  });
}

class MLCaptchaResponse {
  Uint8List? captchaUInt8;
  String? captchaText;
  MLCaptchaResponse({
    this.captchaUInt8,
    this.captchaText,
  });
}

class ImsUrlResponse {
  String? plumUrl;
  String? dashboard;
  String? activities;
  String? registration;
  String? logout;
  ImsUrlResponse({
    this.plumUrl,
    this.dashboard,
    this.activities,
    this.registration,
    this.logout,
  });
}

class AttendanceDataResponse {
  List<AttendanceModelSubWise>? attnData;
  int? semesterNo;
  AttendanceDataResponse({
    this.attnData,
    this.semesterNo,
  });
}

Result errorHandler(Object e) {
  if (e is SocketException) {
    log(e.message);
    return Result.networkError;
  } else if (e is RangeError) {
    log(e.message);
    return Result.internalError;
  } else {
    log((e as DioError).message);
    return Result.internalError;
  }
}
