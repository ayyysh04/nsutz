import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nsutz/controller/datewiseattn_controller.dart';
import 'package:nsutz/theme/constants.dart';

class SubAttnCard extends GetView<DatewiseAttnController> {
  const SubAttnCard({Key? key, required this.date, required this.subData})
      : super(key: key);
  final DateTime date;
  final List<Map<String, String>> subData;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      color: kCardbackgroundcolor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(color: Color(0x90758AA7), width: 1.5),
      ),
      elevation: 6.0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Date heading
            Text(
              toStringDate(date),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Questrial',
                  letterSpacing: 1.1,
                  fontSize: 50.sp),
            ),
            //attendance body
            subjectHeadingBuilder()
          ],
        ),
      ),
    );
  }

  Widget subjectHeadingBuilder() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: subData.length, //no of subjects
        padding: EdgeInsets.symmetric(vertical: 25.h),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          String heading = subData[index].keys.first;

          String value = subData[index].values.first;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 600.w,
                  child: Text(
                    heading,
                    softWrap: true,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontFamily: 'Questrial',
                    ),
                  ),
                ),
                SizedBox(
                  // width: 390.w,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontFamily: 'Questrial',
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
