import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:nsutz/model/attendance_model.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/model/student_model.dart';

class NsutApi {
  var dio = Dio();
  //TODO:no model data will be set here
  //TODO: using interceptor for adding headers -> https://medium.com/flutter-community/dio-interceptors-in-flutter-17be4214f363
  NsutApi() {
    // dio.options.connectTimeout = 10000;
    // dio.options.sendTimeout = 10000;
    // dio.options.receiveTimeout = 10000;
    dio.options.followRedirects = false;
    dio.options.baseUrl = "https://imsnsit.org";
    dio.options.headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36",
      "Origin": "imsnsit.org",
      "Host": "www.imsnsit.org",
    };
  }

  Future<CustomResponse<String>> setCookieAndHeaders(
      {String?
          cookie}) async //retrives phpsesid and set the cookies in header on dio
  {
    try {
      if (dio.options.headers
          .containsKey("Cookie")) //removes previous used cookie if any
      {
        dio.options.headers.remove('Cookie');
      }
      dio.options.headers.addAll({
        "Referer": "https://imsnsit.org/imsnsit/student.htm",
      });
      if (cookie != null) {
        dio.options.headers["Cookie"] = cookie;
      } else {
        await dio.get("/imsnsit/student_login0.php");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 302) {
        var cookie = e.response?.headers.map["set-cookie"]?[0].split(";")[0];
        dio.options.headers["Cookie"] = cookie;
        return CustomResponse(data: cookie);
      } else {
        debugPrint("Network Error");
        return CustomResponse(error: "Network Error");
      }
    }
    return CustomResponse(data: cookie);
  }

  Future<CustomResponse<Map<String, String>>> getCaptcha() async {
    try {
      dio.options.headers.addAll({
        "Referer": "https://www.imsnsit.org/imsnsit/student.htm",
      });

      var resStr = await dio.get("/imsnsit/student_login.php");
      var document = parser.parse(resStr.data);
      Map<String, String> ret = {};
      ret["hrand"] = document.getElementById("HRAND_NUM")!.attributes["value"]!;
      String? imgCaptcha =
          document.getElementById("captchaimg")?.attributes["src"];
      if (imgCaptcha != null) {
        ret["captcha"] = "https://imsnsit.org/imsnsit/" + imgCaptcha;
      }
      return CustomResponse(data: ret);
    } on DioError catch (e) {
      debugPrint("Network Error" + e.response!.statusCode.toString());
      return CustomResponse(error: "Network Error");
      // if (e.response?.statusCode == 302) {}
    }
  }

  Future<CustomResponse<Map<String, String>>> loginAndCheckCaptcha(
    String rollno,
    String password,
    String captcha,
    String hrand,
  ) async //call set cookie before login i.e should call getCaptcha before use
  {
    try {
      var data = {
        "f": "",
        "uid": rollno,
        "pwd": password,
        "HRAND_NUM": hrand,
        "fy": "2022-23",
        "comp": "NETAJI SUBHAS UNIVERSITY OF TECHNOLOGY",
        "cap": captcha,
        "logintype": "student"
      };

      dio.options.headers.addAll({
        "Referer": "https://www.imsnsit.org/imsnsit/student_login.php",
      });

      await dio.post("/imsnsit/student_login.php", data: data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 302) {
        if (e.response?.headers.map["Location"]?[0] != null &&
            e.response?.headers.map["Location"]?[0] !=
                "student_login.php?uid=") //login success
        {
          String plumUrl = "https://www.imsnsit.org/imsnsit/" +
              e.response!.headers.map["Location"]![0];

          return await getStudentImsUrls(plumUrl);
        } else {
          return CustomResponse(error: "wrong captcha/user details");
        }
      } else {
        return CustomResponse(error: "Network Error");
      }
    }
    return CustomResponse(error: "Network Error");
  }

  Future<CustomResponse<Map<String, String>>>
      getStudentImsUrls //get dashboard,activity,regist,logout Url using plumUrl
      (String plumUrl) async {
    try {
      var res = await dio.get(
        plumUrl,
      );
      Map<String, String> ret = {}; //return var
      var document = parser.parse(res.data).getElementsByClassName("tm-bg");
      ret["plumUrl"] = plumUrl;
      ret["dashboard"] = document[0].children[0].attributes["href"]!;
      ret["activities"] = document[1].children[0].attributes["href"]!;
      ret["registration"] = document[2].children[0].attributes["href"]!;
      ret["logout"] = document[4].children[0].attributes["href"]!;
      return CustomResponse(data: ret);
    } on DioError catch (e) {
      debugPrint(e.response?.statusCode.toString());
      return CustomResponse(error: "Network Error");
    }
  }

  Future<CustomResponse<Student>> getStudentProfile(String dashboardUrl) async {
    try {
      dio.options.headers.addAll({
        "Referer": "https://www.imsnsit.org/imsnsit/student_login.php",
      });
      var res = await dio.get(dashboardUrl);
      var document = parser.parse(res.data);
      var allElements = document.querySelectorAll("tr.plum_fieldbig");
      Student studentData = Student();

      studentData.studentImage = CachedNetworkImage(
        imageUrl: "https://www.imsnsit.org/imsnsit/" +
            allElements[0].querySelector("img.round")!.attributes["src"]!,
        httpHeaders: const {
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36",
          "Referer": "https://www.imsnsit.org/imsnsit/student.php",
          "Host": "imsnsit.org",
        },
      );

      studentData.studentID = allElements[2].children[1].text;
      studentData.studentName = allElements[3].children[1].text;
      studentData.studentDOB = allElements[4].children[1].text;
      studentData.studentGender = allElements[5].children[1].text;
      studentData.studentCategory = allElements[6].children[1].text;
      studentData.studentAdmission = allElements[7].children[1].text;
      studentData.studentBranchName = allElements[8].children[1].text;
      studentData.studentDegree = allElements[9].children[1].text;
      studentData.studentFullPart = allElements[10].children[1].text;
      studentData.studentSpecialization = allElements[11].children[1].text;
      studentData.studentSection = allElements[12].children[1].text;

      return CustomResponse(data: studentData);
    } on DioError catch (e) {
      if (e.response!.data
          .toString()
          .contains("Invalid Security Number..Please try again")) {
        return CustomResponse(error: 'wrong captcha');
      } else if (e.response!.data
          .toString()
          .contains("Your password does not match.")) {
        return CustomResponse(error: 'wrong password');
      }
      return CustomResponse(error: "Network Error");
    }
  }

  Future<CustomResponse<Map<String, dynamic>>> getAttendanceData(
      String activityUrl,
      String rollNo,
      String degree,
      String branchName) async {
    try {
      dio.options.headers.addAll({
        "Referer": "https://www.imsnsit.org/imsnsit/student_login.php",
      });
      //activity tab
      var activity = await dio.get(activityUrl);

      if (activity.data.toString().contains("Session")) {
        return CustomResponse(error: 'Session Expired,Relogin');

        // TODO: Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
        // return false;
      }
      var activityDoc = parser.parse(activity.data);

      String semRegisteredLink = activityDoc
          .querySelectorAll("li")[15]
          .querySelector("a")!
          .attributes["href"]!;

      //sem register
      var semRegistered = await dio.get(semRegisteredLink);
      var semRegisteredDoc = parser.parse(semRegistered.data);

      var acadmicData = semRegisteredDoc.body?.text.split("S.No")[0].split(" ");
      String semesterNo = acadmicData!.last;
      String year = acadmicData[acadmicData.length - 3];

      //attendance request
      String attendanceUrl = activityDoc
          .querySelectorAll("li")[14]
          .querySelector("a")!
          .attributes["href"]!;
      var data = {
        "year": year,
        "sem": 3, //semesterNo
        "submit": "Submit",
        "recentitycode": rollNo,
        "degree": degree,
        "dept": branchName,
        "ename": "",
        "ecode": ""
      };

      var attendance = await dio.post(attendanceUrl, data: data);
      if (attendance.data.toString().contains("Session")) {
        return CustomResponse(error: 'Session EXpired,Relogin');

        //TODO: Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
        // return false;
      }
      var attendanceDoc = parser.parse(attendance.data);

      //table plumHead elements
      var trPlumhead = attendanceDoc.querySelectorAll("tr.plum_head");
      //subject codes element
      var subjectElement = trPlumhead[2];
      //table overall elements
      var overallPercentage = trPlumhead[trPlumhead.length - 1];
      var overallPresent = trPlumhead[trPlumhead.length - 2];
      var overallAbsent = trPlumhead[trPlumhead.length - 3];
      var overallClasses = trPlumhead[trPlumhead.length - 4];

      //subeject code names and attendance marked equvalents
      var legends = attendanceDoc.querySelector("tr.plum_fieldbig");

      //tabe tr elements
      var tr = attendanceDoc.querySelectorAll("tr:not(.plum_head)");
      List<AttendanceModel> attendanceData = [];
      for (var i = 1; i < subjectElement.children.length; i++) {
        //assigning to model

        attendanceData.add(AttendanceModel(
            details: [],
            subjectCode: subjectElement.children[i].text,
            overallPresent: overallPresent.children[i].text,
            overallPercentage:
                double.parse(overallPercentage.children[i].text.split("%")[0]),
            overallAbsent: overallAbsent.children[i].text,
            overallClasses: overallClasses.children[i].text));
      }

      for (var i = tr.length - 1; i > 0; i--) {
        if (tr[i].children.length == subjectElement.children.length) {
          var td = tr[i].children;
          for (var i = 1;
              i < td.length;
              i++) //no of subjects wise loop -> 0th index will be date
          {
            attendanceData[i - 1].details!.add({td[0].text: td[i].text});
          }
        }
      }

      return CustomResponse(
          data: {"attnData": attendanceData, "semNo": semesterNo});
    } on DioError catch (e) {
      debugPrint("Error" + e.response!.statusCode.toString());
      return CustomResponse(error: "Network Error");
    }
  }

  // Future<bool> logout(String plumUrl, String logoutUrl) async {
  //TODO: search is logout really works in php site  by using postman and first logout then try if yiu can still retrieve data from plum url or not
  // try {
  //   // dio.options.headers.addAll({
  //   //   "Referer": plumUrl,
  //   // });
  //   Response logout = await dio.get(logoutUrl);
  // } on DioError catch (e) {
  //   if (e.response?.statusCode == 302) {
  //     if (e.response?.headers.map["Location"]?[0] != null &&
  //         e.response?.headers.map["Location"]?[0] ==
  //             "student_login.php") //logout success
  //     {
  //       print(e.response?.headers);
  //       print("log Out success");
  //       return true;
  //     }
  //   } else {
  //     return false;
  //   }
  // }
  // return false;

  // }

}
