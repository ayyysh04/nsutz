import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';

import 'package:nsutz/model/attendance_model.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/model/notice_model.dart';
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
        debugPrint(e.response!.data!.toString());
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
      //TODO:Test app without internet and fix this exception accordingly
      debugPrint("Network Error" + e.response!.statusCode.toString());
      return CustomResponse(error: "Network Error");
      // if (e.response?.statusCode == 302) {}
    }
  }

  Future<CustomResponse<String>> reloadCaptcha(
      String cookie) async //TODO:implement this
  {
    try {
      dio.options.headers.addAll({
        "Referer": "https://www.imsnsit.org/imsnsit/student_login.php",
        "Cookie": cookie
      });

      var resStr =
          await dio.get("/imsnsit/plum5_fw_utils.php?rty=captcha&typ=login");

      var document = parser.parse(resStr.data);
      // ret["hrand"] = //hrand will be same
      String? imgCaptcha =
          document.getElementById("captchaimg")?.attributes["src"];
      if (imgCaptcha == null) {
        throw DioError(
            requestOptions: RequestOptions(path: ""),
            response: Response(requestOptions: RequestOptions(path: "")));
      }
      String imgLink = "https://imsnsit.org/imsnsit/" + imgCaptcha;

      return CustomResponse(data: imgLink);
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
            e.response?.headers.map["Location"]?[0] == "student_login.php") {
          log("reload the session"); //TODO: improve this if else and reload the session
          return CustomResponse(error: "wrong user details");
        } else if (e.response?.headers.map["Location"]?[0] != null &&
            e.response?.headers.map["Location"]?[0] !=
                "student_login.php?uid=") //login success
        {
          String plumUrl = "https://www.imsnsit.org/imsnsit/" +
              e.response!.headers.map["Location"]![0];

          return await getStudentImsUrls(plumUrl);
        } else {
          return CustomResponse(error: "wrong captcha");
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
      if (res.data.toString().contains("Session")) {
        return CustomResponse(error: 'Session Expired,Relogin');
      }
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

      //testing
      // SessionSerivce _sessionService = d.Get.find<SessionSerivce>();
      // print(activityDoc.querySelectorAll("li")[8].querySelector("a")!.text);
      // var ttLink = activityDoc
      // .querySelectorAll("li")[10]
      // .querySelector("a")!
      // .attributes["href"];

      // await getAllTT(_sessionService.sessionData.plumUrl!, ttLink!);
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
        "sem": semesterNo, //semesterNo
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
      if (subjectElement.children.length == 2) {
        // return CustomResponse(error: "No attendance to fetch");
        return CustomResponse(
            data: {"attnData": <AttendanceModel>[], "semNo": semesterNo});
      }

      //table overall elements
      var overallPercentage = trPlumhead[trPlumhead.length - 1];
      var overallPresent = trPlumhead[trPlumhead.length - 2];
      var overallAbsent = trPlumhead[trPlumhead.length - 3];
      var overallClasses = trPlumhead[trPlumhead.length - 4];

      //legends
      var legends = attendanceDoc
          .querySelector("tr.plum_fieldbig")!
          .querySelectorAll('b');
      // log(attendance.data.toString()); //USE LOG TO PRINT BIG STATEMENT

      //subject codes and name
      List<String> subCodeEquvalent = legends[0].innerHtml.split("<br>");
      // legends
      //[1].innerHtml.split("<br>");

      //TODO:match the equivalent with data and replace it using a temporary map<String,String>
      Map<String, String> attnMarkEquivalent = {
        "CR": "Class Rescheduled",
        "CS": "Class Suspended",
        "GH": "Gazetted Holiday",
        "MB": "Mass Bunk",
        "MS": "Mid Sem Exam",
        "NA": "Timetable Not Allotted",
        "NT": "Class Not Taken",
        "OD": "Teacher on Official duty",
        "TL": "Teacher on Leave",
        "1+1": "2",
        "1": "1"
      }; //HardCoded

      //tabe tr elements
      var tr = attendanceDoc.querySelectorAll("tr:not(.plum_head)");
      List<AttendanceModel> attendanceData = [];
      for (var i = 1; i < subjectElement.children.length; i++) {
        //assigning to model

        attendanceData.add(AttendanceModel(
            details: [],
            subjectName: subCodeEquvalent[i - 1].split("-")[1],
            subjectCode: subjectElement.children[i].text,
            overallPresent: overallPresent.children[i].text,
            overallPercentage:
                double.parse(overallPercentage.children[i].text.split("%")[0]),
            overallAbsent: overallAbsent.children[i].text,
            overallClasses: overallClasses.children[i].text));
      }

      //TODO:Tp sort the date issue : dec 2021 to jan 2022 ,see my 2020 ims profile attn of sem 1 at 2020-21
      int todaysDate = getTodaysDecryptedDate();
      for (var i = tr.length - 1; i >= 0; i--) {
        if (tr[i].children.length == subjectElement.children.length &&
            getdecryptedDate(tr[i].children[0].text) <=
                todaysDate) //only see that row which has attn data not the heading or etc
        {
          var td = tr[i].children; //get date and attn data row individually
          for (var i = 1;
              i < td.length;
              i++) //no of subjects wise loop -> 0th index will be date
          {
            String fullLegend = attnMarkEquivalent[td[i].text] ?? td[i].text;
            attendanceData[i - 1].details!.add({td[0].text: fullLegend});
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

  //TODO: make a seprate scrape call to get attendance and store in datewise order : THIS WILL INCRESE LOCAL STORAGE USAGE OF THE APP

  //TODO:UNDERDEVELOPMENT
  Future<void> getAllTT(String plumUrl, String ttUrl) async {
    List<List<Subject>> TT = [];
    TT.add((await getTimetable(plumUrl, ttUrl, "Mon"))!);
    TT.add((await getTimetable(plumUrl, ttUrl, "Tue"))!);
    TT.add((await getTimetable(plumUrl, ttUrl, "Wed"))!);
    TT.add((await getTimetable(plumUrl, ttUrl, "Thu"))!);
    TT.add((await getTimetable(plumUrl, ttUrl, "Fri"))!);

    // print(TT[0][1].teachers.toString());
  }

  Future<List<Subject>?> getTimetable(
    String plumUrl,
    String ttUrl,
    String day,
  ) async {
    var data = {
      "sem": "2",
      "sec": "2",
      "degree": "B.Tech.",
      "subdepartment": "INFORMATION TECHNOLOGY",
      "spec": "INFORMATION TECHNOLOGY",
      "wkd": day,
      "submit": "Go"
    };
    try {
      dio.options.headers.addAll({
        "Referer": plumUrl,
      });
      List<Subject> subTT = [];
      Response ttRes = await dio.post(ttUrl, data: data);
      var activityDoc = parser.parse(ttRes.data);
      var table = activityDoc
          .querySelectorAll("table.plum_fieldbig")[1]
          .getElementsByTagName("tr");
      for (var tr in table) {
        late Subject temp = Subject(teachers: []);
        for (var td in tr.children) {
          var substr1 = td.text.split(" - ");

          temp = Subject(subCode: substr1[0], teachers: []);
          var substr2 = substr1[1].split(" / ");
          // print(substr2.toString());
          Map<String, String> data = {};

          data.addAll({substr2[0]: substr2[1]});
          temp.teachers.add(data);
        }
        subTT.add(temp);
        return subTT;
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  //NOTICES
  Future<CustomResponse<List<NoticeModel>>> getNotices() async {
    try {
      dio.options.headers.addAll({
        "Referer": "https://www.imsnsit.org/imsnsit/",
      });
      List<NoticeModel> noticesLink = [];
      Response noticeRes =
          await dio.get("https://www.imsnsit.org/imsnsit/notifications.php");
      var activityDoc = parser.parse(noticeRes.data);
      var tableRows = activityDoc.querySelectorAll("tr");

      for (int i = 4; i < tableRows.length; i++) {
        var row = tableRows[i];
        var rowChildren = row.querySelectorAll("td");
        if (rowChildren.length == 2) {
          if (rowChildren[1].querySelector('a') == null) {
            noticesLink.add(NoticeModel(
                notice: rowChildren[1].children[0].text,
                publishedBy: rowChildren[1].children[2].text,
                date: rowChildren[0].text));
          } else {
            noticesLink.add(NoticeModel(
              date: rowChildren[0].text,
              notice: rowChildren[1].children[0].text,
              url: rowChildren[1].children[0].attributes["href"]!,
              publishedBy: rowChildren[1].children[2].text,
            ));
          }
        }
      }
      return CustomResponse(data: noticesLink);
    } on DioError catch (e) {
      debugPrint(e.message);
      return CustomResponse(error: "Network error");
    }
  }

  Future<CustomResponse<List<NoticeModel>>> getOldNotices() async {
    try {
      dio.options.headers.addAll({
        "Referer": "https://www.imsnsit.org/imsnsit/",
      });
      List<NoticeModel> noticesLink = [];
      var data = {
        "branch": "All",
        "olddata": "Archive: Click to View Old Notices / Circulars"
      };
      Response noticeRes = await dio.post(
          "https://www.imsnsit.org/imsnsit/notifications.php",
          data: data);
      var activityDoc = parser.parse(noticeRes.data);
      var tableRows = activityDoc.querySelectorAll("tr");

      for (int i = 4; i < tableRows.length; i++) {
        var row = tableRows[i];
        var rowChildren = row.querySelectorAll("td");
        if (rowChildren.length == 2) {
          if (rowChildren[1].querySelector('a') == null) {
            var splitNotice =
                rowChildren[1].children[0].text.split("Published By:");

            noticesLink.add(NoticeModel(
                notice: splitNotice[0],
                publishedBy: "Published By:" + splitNotice[1],
                date: rowChildren[0].text));
          } else {
            noticesLink.add(NoticeModel(
              date: rowChildren[0].text,
              notice: rowChildren[1].children[0].text,
              url: rowChildren[1].children[0].attributes["href"]!,
              publishedBy: rowChildren[1].children[2].text,
            ));
          }
        }
      }
      return CustomResponse(data: noticesLink);
    } on DioError catch (e) {
      debugPrint(e.message);
      return CustomResponse(error: "Network error");
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

int getdecryptedDate(String enncodedDate) {
  var splitEncDate = enncodedDate.split("-");
  String endcodedMonth = splitEncDate[0];
  String day = splitEncDate[1];
  String? month;

  if (endcodedMonth == "Dec") {
    month = "12";
  } else if (endcodedMonth == "Nov") {
    month = "11";
  } else if (endcodedMonth == "Oct") {
    month = "10";
  } else if (endcodedMonth == "Sep") {
    month = "09";
  } else if (endcodedMonth == "Aug") {
    month = "08";
  } else if (endcodedMonth == "Jul") {
    month = "07";
  } else if (endcodedMonth == "Jun") {
    month = "06";
  } else if (endcodedMonth == "May") {
    month = "05";
  } else if (endcodedMonth == "Apr") {
    month = "04";
  } else if (endcodedMonth == "Mar") {
    month = "03";
  } else if (endcodedMonth == "Feb") {
    month = "02";
  } else if (endcodedMonth == "Jan") {
    month = "01";
  }
  var date = "2022$month$day";
  return int.parse(date);
}

int getTodaysDecryptedDate() {
//YYMMDD - 20210504
  NumberFormat formatter = NumberFormat("00");
  var todaysDate = DateTime.now();
  var stringTodaysDate =
      "${todaysDate.year}${formatter.format(todaysDate.month)}${formatter.format(todaysDate.day)}";

  return int.parse(stringTodaysDate);
}

class Subject {
  String? subCode;
  List<Map<String, String>> teachers;
  //grp or tut : teacher
  Subject({this.subCode, required this.teachers});
}
