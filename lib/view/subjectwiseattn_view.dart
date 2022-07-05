import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nsutz/controller/subjectwiseattn_controller.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:nsutz/view/widgets/subdaywisecard_builder.dart';

class SubjectWiseAttnView extends GetView<SubjectWiseAttnController> {
  final String subjectCode;
  final String subjectName;
  SubjectWiseAttnView({
    Key? key,
    required this.subjectCode,
    required this.subjectName,
  }) : super(key: key);
  final DateTime todayDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          subjectCode,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Questrial',
          ),
        ),
        actions: [
          GestureDetector(
            onTap: controller.refreshAttnData,
            child: Icon(
              Icons.refresh,
              size: 30,
            ),
          ),
          SizedBox(
            width: 40.w,
          )
        ],
        bottom: PreferredSize(
          child: Expanded(
            child: Center(
              child: Text(
                subjectName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Questrial',
                  fontSize: 60.sp,
                ),
              ),
            ),
          ),
          preferredSize: Size(0.0, 110.h),
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
            child: GetBuilder<SubjectWiseAttnController>(builder: (_) {
              return FutureBuilder<String>(
                  future: controller.getStudentAttendance(subjectCode),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //subject heading
                        Center(
                            child: Card(
                                color: getcolor(
                                    controller.subAttnData.overallPercentage!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(70.h),
                                ),
                                elevation: 6.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 65.w, vertical: 55.h),
                                  child: Text(
                                    ' ${controller.subAttnData.overallPresent} of ${controller.subAttnData.overallClasses} Classes attended',
                                    style: TextStyle(
                                      fontSize: 60.sp,
                                      fontFamily: 'Questrial',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ))),
                        SizedBox(
                          height: 20.h,
                        ),
                        //all subjects cards
                        Expanded(flex: 9, child: SubDayCardListBuilder()),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    );
                  }));
            })),
      ),
    );
  }

  Color getcolor(double percent) {
    if (percent >= 75.0) {
      return kLightgreen;
    } else if (percent >= 55.0) {
      return kLightYellow;
    } else {
      return kLightred;
    }
  }
}
