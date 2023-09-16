import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:get/utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import 'package:nsutz/model/attendance_model.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/model/notice_model.dart';
import 'package:nsutz/model/student_model.dart';

//TODO:DONT RETURN NETWORK ERROR RESULT ,JUST UPDATE IT IN NETWROK CONNECTION SERVICE
//TODO:DONT RETURN INTERNAL ERROR ,SHOW A DIALOG BOX THAT A INTERNAL APP ERROR HAS OCCURED
class NsutApi {
  final _dio = Dio();
  //TODO: find ways to use less selectors and extracts using split based on content of string
  //TODONOTE:no model data will be set here
  //TODO: using interceptor for adding headers -> https://medium.com/flutter-community/dio-interceptors-in-flutter-17be4214f363
  NsutApi() {
    // dio.options.connectTimeout = 10000;
    // dio.options.sendTimeout = 10000;
    // dio.options.receiveTimeout = 10000;

    _dio.options.followRedirects = false;
    _dio.options.baseUrl = "https://imsnsit.org";
    _dio.options.headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36",
      "Origin": "imsnsit.org",
      "Host": "www.imsnsit.org",
    };
  }

  ///result : success , network error
  ///
  ///cookieArg -> set prev session cookie to header
  ///
  ///no parameter -> set new session cookie to header
  Future<CustomResponse<String>> setCookieAndHeaders(
      {String?
          cookieArg}) async //retrives phpsesid and set the cookies in header on dio
  {
    //checking cookie header and remove if already
    _dio.options.headers.remove('Cookie');
    _dio.options.headers.addAll({
      "Referer": "https://imsnsit.org/imsnsit/student.htm",
    });

    //adding new cookie
    if (cookieArg != null) //if cookie given : resume session ->return
    {
      _dio.options.headers["Cookie"] = cookieArg;
      return CustomResponse(data: cookieArg, res: Result.success);
    } else //else get new cookie
    {
      try {
        await _dio.get(
          "/imsnsit/student_login0.php",
        ); //give response as 302 ,as Dioerror ->go to Dioerror block

      } catch (e) {
        if (e is DioError) {
          if (e.response != null && e.response!.statusCode == 302) //successfull
          {
            var cookie =
                e.response!.headers.map["set-cookie"]?[0].split(";")[0];
            if (cookie != null) {
              printInfo(info: e.response!.data!.toString());
              _dio.options.headers["Cookie"] = cookie;
              return CustomResponse(data: cookie, res: Result.success);
            }
          }
        } else if (e is SocketException) {
          return CustomResponse(res: Result.networkError);
        }
      }
    }
    return CustomResponse(res: Result.internalError);
  }

  ///result : NetworkError
  ///
  ///data : String? hrand | Uint8List? captchaUInt8
  Future<CustomResponse<CaptchaResponse>> getCaptcha() async {
    //adding new header
    _dio.options.headers.addAll({
      "Referer": "https://www.imsnsit.org/imsnsit/student.htm",
    });
    try {
      var resStr = await _dio.get("/imsnsit/student_login.php");
      var document = parser.parse(resStr.data);
      if (document.getElementById("HRAND_NUM") != null &&
          document.getElementById("captchaimg") != null) {
        String hrand =
            document.getElementById("HRAND_NUM")!.attributes["value"]!;
        String imgCaptcha = "https://imsnsit.org/imsnsit/" +
            document.getElementById("captchaimg")!.attributes["src"]!;

        //getting captcha image
        var response = await http.get(Uri.parse(imgCaptcha), headers: {
          "Referer": "https://www.imsnsit.org/imsnsit/student.php",
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36",
          "Host": "imsnsit.org",
        });

        //storing image as Uint8List
        Uint8List captchaUInt8 = response.bodyBytes;
        printInfo(info: response.bodyBytes.length.toString());

        return CustomResponse(
            data: CaptchaResponse(captchaUInt8: captchaUInt8, hrand: hrand),
            res: Result.success);
      }
    } catch (e) {
      return CustomResponse(res: errorHandler(e));
      //TODO:Test app without internet and fix this exception accordingly

    }
    return CustomResponse(res: Result.internalError);
  }

  ///network error , sucess
  Future<CustomResponse<CaptchaResponse>> reloadCaptcha() async {
    _dio.options.headers.addAll({
      "Referer": "https://www.imsnsit.org/imsnsit/student_login.php",
    });

    try {
      var resStr =
          await _dio.get("/imsnsit/plum5_fw_utils.php?rty=captcha&typ=login");

      var capDoc = parser.parse(resStr.data);
      //hrand will be same
      if (capDoc.getElementById("captchaimg") != null) {
        String imgCaptcha = "https://imsnsit.org/imsnsit/" +
            capDoc.getElementById("captchaimg")!.attributes["src"]!;

        //getting captcha image
        var capRes = await http.get(Uri.parse(imgCaptcha), headers: {
          "Referer": "https://www.imsnsit.org/imsnsit/student.php",
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36",
          "Host": "imsnsit.org",
        });

        //storing image as Uint8List
        Uint8List captchaUInt8 = capRes.bodyBytes;
        printInfo(info: capRes.bodyBytes.length.toString());
        return CustomResponse(
            res: Result.success,
            data: CaptchaResponse(captchaUInt8: captchaUInt8));
      }
    } catch (e) {
      return CustomResponse(res: errorHandler(e));
    }
    return CustomResponse(res: Result.internalError);
  }

  //NOTE:WHEN PASSWORD OR USERNAME ERROR OCCURS WHILE LOGIN ,YOU NEED TO REFRESH THE SESSION
  //WHEN CAPTCHA ERROR OCCURS ,YOU CAN USE THE SAME SESSION
  ///result : invalidSession ,network error ,success ,invalidCaptcha
  ///
  ///arg : rollno | password | catcha | hrand
  Future<CustomResponse<String?>> loginUsingCaptcha(
    String rollno,
    String password,
    String captcha,
    String hrand,
  ) async //call set cookie before login i.e should call getCaptcha before use
  {
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

    _dio.options.headers.addAll({
      "Referer": "https://www.imsnsit.org/imsnsit/student_login.php",
    });

    try {
      await _dio.post("/imsnsit/student_login.php",
          data: data); //success if status code 302 else error
    } catch (e) {
      if (e is DioError) {
        if (e.response != null &&
            e.response!.statusCode == 302 &&
            e.response!.headers.map["Location"]?[0] != null) {
          if (e.response!.headers.map["Location"]?[0] ==
              "student_login.php") //invalid session : wrong pass or username or wrong cookie
          {
            return CustomResponse(res: Result.invalidSession);
          } else if (e.response!.headers.map["Location"]![0] !=
                  "student_login.php?uid=" &&
              e.response!.headers.map["Location"]![0] !=
                  "plum5_fw_login.php?uid=") //login success
          {
            String plumUrl = "https://www.imsnsit.org/imsnsit/" +
                e.response!.headers.map["Location"]![0];
            return CustomResponse(res: Result.success, data: plumUrl);
          } else {
            return CustomResponse(res: Result.invalidCaptcha);
          }
        }
      } else if (e is SocketException) {
        return CustomResponse(res: Result.networkError);
      }
    }
    return CustomResponse(res: Result.internalError);
  }

  ///result : invalid seession ,network error , success
  ///
  ///Data : String? plumUrl | String? dashboard | String? activities | String? registration | String? logout
  ///
  ///arg : plumUrl
  Future<CustomResponse<ImsUrlResponse>>
      getStudentImsUrls //get dashboard,activity,regist,logout Url using plumUrl
      (String plumUrl) async {
    try {
      var res = await _dio.get(
        plumUrl,
      );
      if (res.data.toString().contains("Session") ||
          res.data.toString().contains("Invalid Login..Please try again")) {
        return CustomResponse(res: Result.invalidSession); //cookie expired
      }
      ImsUrlResponse ret = ImsUrlResponse();
      var document = parser.parse(res.data).getElementsByClassName("tm-bg");
      ret.plumUrl = plumUrl;
      ret.dashboard = document[0].children[0].attributes["href"]!;
      ret.activities = document[1].children[0].attributes["href"]!;
      ret.registration = document[2].children[0].attributes["href"]!;
      ret.logout = document[4].children[0].attributes["href"]!;
      return CustomResponse(res: Result.success, data: ret); //success return
    } catch (e) {
      return CustomResponse(res: errorHandler(e));
    }
  }

  ///result : success , invalidPassword,invalidCaptcha , NetworkError | data if success
  ///
  ///arg:dashboardUrl
  Future<CustomResponse<Student>> getStudentProfile(String dashboardUrl) async {
    _dio.options.headers.addAll({
      "Referer": "https://www.imsnsit.org/imsnsit/student_login.php",
    });
    try {
      var res = await _dio.get(dashboardUrl);
      var document = parser.parse(res.data);
      var allElements = document.querySelectorAll("tr.plum_fieldbig");

      //downloading student profile as UInt8List
      var stuProfileRes = await http.get(
          Uri.parse("https://www.imsnsit.org/imsnsit/" +
              allElements[0].querySelector("img.round")!.attributes["src"]!),
          headers: {
            "User-Agent":
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36",
            "Referer": "https://www.imsnsit.org/imsnsit/student.php",
            "Host": "imsnsit.org",
          });

      Uint8List stuProfileUInt8 = stuProfileRes.bodyBytes;
      Student studentData = Student.fromStudent(
        studentImage: stuProfileUInt8,
        studentID: allElements[2].children[1].text,
        studentName: allElements[3].children[1].text,
        studentDOB: allElements[4].children[1].text,
        studentGender: allElements[5].children[1].text,
        studentCategory: allElements[6].children[1].text,
        studentAdmission: allElements[7].children[1].text,
        studentBranchName: allElements[8].children[1].text,
        studentDegree: allElements[9].children[1].text,
        studentFullPart: allElements[10].children[1].text,
        studentSpecialization: allElements[11].children[1].text,
        studentSection: allElements[12].children[1].text,
      );

      return CustomResponse(data: studentData, res: Result.success);
    } catch (e) {
      if (e is DioError) {
        if (e.response!.data
            .toString()
            .contains("Invalid Security Number..Please try again")) {
          return CustomResponse(res: Result.invalidCaptcha);
        } else if (e.response!.data
            .toString()
            .contains("Your password does not match.")) {
          return CustomResponse(res: Result.invalidPassword);
        }
      } else if (e is SocketException) {
        return CustomResponse(res: Result.networkError);
      }
    }
    return CustomResponse(res: Result.internalError);
  }

  ///Result : invalidSession ,networkError,Success
  ///
  ///Attn data : List<AttendanceModelSubWise>? attnData | int? semesterNo
  ///
  ///arg : activityUrl , rollno ,degree,branchName
  Future<CustomResponse<AttendanceDataResponse>> getAttendanceData(
      String activityUrl,
      String rollNo,
      String degree,
      String branchName) async {
    _dio.options.headers.addAll({
      "Referer": "https://www.imsnsit.org/imsnsit/student_login.php",
    });
    try {
      //activity tab
      var activity = await _dio.get(activityUrl);

      if (activity.data.toString().contains("Session")) {
        return CustomResponse(res: Result.invalidSession);

        //TODO: new update : show password customDialog ,there add button for reLogin
      }
      var activityDoc = parser.parse(activity.data);
      //time table
      // TODO : find practical course and their respective day
      var pracDay = {};
      String myTimetableLink = activityDoc
          .querySelectorAll("li")[8]
          .querySelector("a")!
          .attributes["href"]!;
      var myTimeTable = await _dio.get(myTimetableLink);
      var myTimeTableDoc = parser.parse(myTimeTable.data);
      var trRows = myTimeTableDoc.querySelectorAll("tr");
      // 0 - day
      for (var i = 2; i < 7; i++) {
        for (var j = 1; j < trRows[i].children.length; j++) {
          if (trRows[i].children[j].text.contains('Grp')) {
            pracDay[trRows[i].children[j].text.split('-Sec:')[0]] =
                trRows[i].children[0].text;
          }
        }
      }
      var ttHead = trRows[0].children[0].text.split("Academic Year : ")[1];
      var ttHeadData = ttHead.split(" / Semester : ");
      int semesterNo = int.parse(ttHeadData[1]);
      String year = ttHeadData[0];
      // int semesterNo = int.parse(acadmicData!.last);
      // String year = acadmicData[acadmicData.length - 3];

      //semester registration
      String semRegisteredLink = activityDoc
          .querySelectorAll("li")[15]
          .querySelector("a")!
          .attributes["href"]!;

      //sem register TODO: removed and used tt data to get req data
      // var semRegistered = await _dio.get(semRegisteredLink);
      // var semRegisteredDoc = parser.parse(semRegistered.data);
      // TODO : find practical course and their respective day
      // var acadmicData = semRegisteredDoc.body?.text.split("S.No")[0].split(" ");
      // int semesterNo = int.parse(acadmicData!.last);
      // String year = acadmicData[acadmicData.length - 3];

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

      var attendance = await _dio.post(attendanceUrl, data: data);
      if (attendance.data.toString().contains("Session")) {
        return CustomResponse(res: Result.invalidSession);
      }
      var attendanceDoc = parser.parse(attendance.data);

      //table plumHead elements
      var trPlumhead = attendanceDoc.querySelectorAll("tr.plum_head");

      //subject codes element
      var subjectElement = trPlumhead[2];
      if (subjectElement.children.length == 2) {
        // return CustomResponse(error: "No attendance to fetch");
        return CustomResponse(
            data: AttendanceDataResponse(attnData: [], semesterNo: semesterNo),
            res: Result.success);
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
      List<AttendanceModelSubWise> attendanceData = [];
      for (var i = 1; i < subjectElement.children.length; i++) {
        //assigning to model

        attendanceData.add(
          AttendanceModelSubWise(
              details: [],
              subjectName: subCodeEquvalent[i - 1].split("-")[1],
              subjectCode: subjectElement.children[i].text,
              overallPresent: int.parse(overallPresent.children[i].text),
              overallPercentage: double.parse(
                  overallPercentage.children[i].text.split("%")[0]),
              overallAbsent: int.parse(overallAbsent.children[i].text),
              overallClasses: int.parse(overallClasses.children[i].text),
              pracDay: pracDay[subjectElement.children[i].text]),
        );
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
            // String fullLegend = attnMarkEquivalent[td[i].text] ?? td[i].text;
            // attendanceData[i - 1].details!.add({td[0].text: fullLegend});
            //TODO:find a way to put year in toDate function according to some logic
            //TODO:make this more cleaner using modelclass converter

            if (td[i].text == '') //no attendance marked case
            {
              attendanceData[i - 1]
                  .details!
                  .add({toDate(td[0].text, "2022"): 'NM'});
            } else {
              attendanceData[i - 1]
                  .details!
                  .add({toDate(td[0].text, "2022"): td[i].text});
            }
          }
        }
      }
      print(pracDay);
      return CustomResponse(
          data: AttendanceDataResponse(
              attnData: attendanceData, semesterNo: semesterNo),
          res: Result.success);
    } catch (e) {
      return CustomResponse(res: errorHandler(e));
    }
  }

  //NOTICES
  ///result : success.networkError
  ///data : List [String notice | String? url | DateTime date | String publishedBy]
  Future<CustomResponse<List<NoticeModel>>> getNotices() async {
    try {
      _dio.options.headers.addAll({
        "Referer": "https://www.imsnsit.org/imsnsit/",
      });
      List<NoticeModel> noticesLink = [];
      Response noticeRes =
          await _dio.get("https://www.imsnsit.org/imsnsit/notifications.php");
      var activityDoc = parser.parse(noticeRes.data);
      var tableRows = activityDoc.querySelectorAll("tr");

      for (int i = 4; i < tableRows.length; i++) {
        var row = tableRows[i];
        var rowChildren = row.querySelectorAll("td");
        if (rowChildren.length == 2) {
          if (rowChildren[1].querySelector('a') == null) {
            noticesLink.add(NoticeModel(
                notice: row.text.split("Published By:")[0].substring(10),
                publishedBy: row.text.split("Published By:")[1],
                date: NoticeModel.toDate(row.text.substring(0, 10))));
          } else {
            noticesLink.add(NoticeModel(
              notice: row.text.split("Published By:")[0].substring(11),
              publishedBy: row.text.split("Published By:")[1],
              date: NoticeModel.toDate(row.text.substring(0, 10)),
              url: rowChildren[1].children[0].attributes["href"]!,
            ));
          }
        }
      }
      return CustomResponse(data: noticesLink, res: Result.success);
    } on DioError catch (e) {
      return CustomResponse(res: errorHandler(e));
    }
  }

  ///result : success.networkError
  ///data : List [String notice | String? url | DateTime date | String publishedBy]
  Future<CustomResponse<List<NoticeModel>>> getOldNotices() async {
    _dio.options.headers.addAll({
      "Referer": "https://www.imsnsit.org/imsnsit/",
    });
    List<NoticeModel> noticesLink = [];
    var data = {
      "branch": "All",
      "olddata": "Archive: Click to View Old Notices / Circulars"
    };
    try {
      Response noticeRes = await _dio.post(
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
                publishedBy: splitNotice[1],
                date: NoticeModel.toDate(rowChildren[0].text)));
          } else {
            noticesLink.add(NoticeModel(
              date: NoticeModel.toDate(rowChildren[0].text),
              notice: rowChildren[1].children[0].text,
              url: rowChildren[1].children[0].attributes["href"]!,
              publishedBy:
                  rowChildren[1].children[2].text.split("Published By:")[1],
            ));
          }
        }
      }
      return CustomResponse(data: noticesLink, res: Result.success);
    } on DioError catch (e) {
      return CustomResponse(res: errorHandler(e));
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
