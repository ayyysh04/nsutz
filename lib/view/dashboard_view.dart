import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/controller/dashboard_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:nsutz/view/widgets/subjectcard_listbuilder.dart';

class DashboardView extends GetView<DashboardController> {
  DashboardView({Key? key}) : super(key: key);
  final DateTime todayDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Dashboard"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: Icon(
                Icons.account_circle,
                size: 30.0,
              ),
              onTap: controller.openStuentProfile,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${controller.getGreetingName()}',
                style: TextStyle(
                  fontSize: 60.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              //rich text date
              Text(
                weekdays[todayDate.weekday],
                style: TextStyle(
                  fontFamily: 'Questrial',
                  fontSize: 45.sp,
                ),
              ),
              EasyRichText(
                "${todayDate.day}${controller.getsuperscript(todayDate.day)} ${months[todayDate.month]}  ${todayDate.year}",
                patternList: [
                  EasyRichTextPattern(
                    targetString: '${todayDate.day}',
                    style: TextStyle(
                      fontSize: 100.sp,
                      fontFamily: 'Questrial',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  EasyRichTextPattern(
                    targetString: months[todayDate.month],
                    style: TextStyle(
                      fontSize: 70.sp,
                      fontFamily: 'Questrial',
                    ),
                  ),
                  EasyRichTextPattern(
                    targetString: '${todayDate.year}',
                    style: TextStyle(
                      fontSize: 70.sp,
                      fontFamily: 'Questrial',
                    ),
                  ),
                  EasyRichTextPattern(
                    targetString: controller.getsuperscript(todayDate.day),
                    superScript: true,
                    stringBeforeTarget: '${todayDate.day}',
                    matchWordBoundaries: false,
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 70.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 80.h,
              ),
              //subject heading

              Row(
                children: [
                  Text(
                    ' Subjects',
                    style: TextStyle(
                      fontSize: 60.sp,
                      fontFamily: 'Questrial',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    // flex: 3,
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey[300],
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.refreshAttnData,
                    child: Icon(
                      Icons.refresh,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              //all subjects cards
              Expanded(
                flex: 9,
                child: GetBuilder<DashboardController>(builder: (_) {
                  return FutureBuilder<String?>(
                      future: controller.getStudentAttendance(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: kLightgreen,
                          ));
                        } else if (snapshot.hasError || snapshot.data == null) {
                          return Center(
                            child: Text(
                              'Error! Press Refresh to load',
                              style: TextStyle(
                                fontSize: 50.sp,
                                fontFamily: 'Questrial',
                              ),
                            ),
                          );
                        }
                        return SubjectCardListBuilder();
                      }));
                }),
              ),
              SizedBox(
                height: 20.0,
              ),
              //Data wise attendance button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo[400],
                  ),
                  onPressed: controller.openDateWisePage,
                  child: Text(
                    'View Datewise Attendance',
                    style: TextStyle(
                      fontSize: 50.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
