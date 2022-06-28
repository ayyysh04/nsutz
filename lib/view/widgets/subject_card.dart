// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SubjectsCard extends StatelessWidget {
  const SubjectsCard({
    Key? key,
    required this.percent,
    required this.subject,
  }) : super(key: key);
  final double percent;
  final String subject;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 15.w),
      color: kCardbackgroundcolor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      elevation: 6.0,
      child: Tooltip(
        message: '{$subject} Attendance',
        child: Container(
          height: 340.h,
          padding: EdgeInsets.symmetric(
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
                  getMsg(percent),
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
    if (percent >= 75.0)
      return kLightgreen;
    else if (percent >= 55.0)
      return kLightYellow;
    else
      return kLightred;
  }

  String getMsg(double percent) {
    if (percent >= 75.0)
      return "Safe! You can take leave for x classes";
    else if (percent >= 55.0)
      return "Unsafe! Attend x class to enter green zone";
    else
      return "Too low attendance! Attend x class to enter green zone";
  }
}
