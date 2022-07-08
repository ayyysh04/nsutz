// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SubjectsCard extends StatelessWidget {
  const SubjectsCard({
    Key? key,
    required this.overallClasses,
    required this.presentClasses,
    required this.percent,
    required this.subject,
  }) : super(key: key);
  final double percent;
  final String subject;
  final int overallClasses;
  final int presentClasses;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 15.w),
      color: kCardbackgroundcolor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(55.w),
      ),
      elevation: 6.0,
      child: Tooltip(
        message: '{$subject} Attendance',
        child: Container(
          // height: 340.h,
          // margin: EdgeInsets.symmetric(vertical: 10.w),
          padding: EdgeInsets.symmetric(
            vertical: 65.h,
            horizontal: 65.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                subject,
                style: TextStyle(
                  fontFamily: 'Questrial',
                  fontSize: 45.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              //linear percentage Indicator
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        padding: EdgeInsets.all(0),
                        animation: true,
                        lineHeight: 18.h,
                        animationDuration: 1000,
                        percent: percent / 100,
                        barRadius: Radius.circular(18.h / 2),
                        progressColor: getcolor(percent),
                        backgroundColor: Color(0xFF212D49),
                        curve: Curves.linearToEaseOut,
                      ),
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    Text(
                      '${percent.toStringAsFixed(2)}%',
                      maxLines: 1,
                      style: TextStyle(
                        color: getcolor(percent),
                        fontSize: 52.sp,
                        fontFamily: 'Questrial',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Text(
                  getMsg(percent, overallClasses, presentClasses),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    fontSize: 45.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getcolor(double percent) {
    if (percent == 0) return kLightgreen; //no lecture conducted

    if (percent >= 75.0)
      return kLightgreen;
    else if (percent >= 55.0)
      return kLightYellow;
    else
      return kLightred;
  }

  String getMsg(double percent, int overallClasses, int presentClasses) {
    int count = 0;

    if ((percent > 75)) //to take leave
    {
      count = ((presentClasses / 0.75) - overallClasses).floor();
    } else if ((percent < 75)) //to get 75
    {
      count = (((overallClasses * 0.75) - presentClasses) / 0.25).floor();
    }

    if (percent == 75) {
      return "Safe! You cannot take a leave right now";
    } else if (percent > 75.0) {
      return "Safe! You can take leave for $count classes";
    } else if (percent >= 55.0) {
      return "Unsafe! Attend $count class to enter green zone";
    } else if (percent > 0) {
      return "Too low attendance! Attend $count class to enter green zone";
    } else {
      return "classes not started yet!";
    }
  }
}
