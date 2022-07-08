// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'package:nsutz/controller/subjectwiseattn_controller.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:nsutz/view/widgets/attn_symbols/attn_symbols.dart';

class SubDayCardListBuilder extends GetView<SubjectWiseAttnController> {
  const SubDayCardListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        controller: ScrollController(),
        physics: BouncingScrollPhysics(),
        itemCount: controller.subAttnData.details!.length,
        itemBuilder: (context, itemNo) {
          return AnimationConfiguration.staggeredList(
              position: itemNo,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                  verticalOffset: 80.0,
                  child: FadeInAnimation(
                      child: SubDayCard(
                    tooltipMsg: controller.getTooltipMsg(
                        controller.subAttnData.details![itemNo].values.first),
                    ispresent: controller.getIsPresent(
                        controller.subAttnData.details![itemNo].values.first),
                    date: controller.subAttnData.details![itemNo].keys.first,
                    attnMarkWidget: controller.getAttendanceIcon(
                        controller.subAttnData.details![itemNo].values.first),
                  ))));
        },
      ),
    );
  }
}

class SubDayCard extends StatelessWidget {
  const SubDayCard({
    Key? key,
    required this.tooltipMsg,
    required this.ispresent,
    required this.date,
    required this.attnMarkWidget,
  }) : super(key: key);
  final String tooltipMsg;
  final bool? ispresent;
  final String date;
  final dynamic attnMarkWidget;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 15.h),
        color: kCardbackgroundcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.w),
        ),
        elevation: 6.0,
        child: Tooltip(
          message: tooltipMsg,
          child: Container(
            // height: 180.h,
            padding: EdgeInsets.symmetric(
              horizontal: 65.w,
              vertical: 35.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    fontSize: 50.sp,
                  ),
                ),
                attnMarkWidget,
              ],
            ),
          ),
        ));
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
