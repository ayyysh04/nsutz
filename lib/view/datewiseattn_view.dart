import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nsutz/controller/datewiseattn_controller.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nsutz/view/widgets/subattncard_builder.dart';

class DatewiseAttnView extends GetView<DatewiseAttnController> {
  const DatewiseAttnView({Key? key}) : super(key: key);
  wid() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Date Wise Attendance',
      ),
      actions: [
        Row(
          children: [
            IconButton(
              // padding: EdgeInsets.symmetric(horizontal: 20),
              // splashColor: Colors.transparent,
              // highlightColor: Colors.transparent,
              icon: Icon(FontAwesomeIcons.sort),
              onPressed: () {
                controller.reverseAttnDateWise();
              },
            ),
            IconButton(
              // padding: EdgeInsets.symmetric(horizontal: 20),
              icon: Icon(Icons.refresh),
              onPressed: () {
                controller.resetSearch();
              },
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.backButtonCallBack,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.indigo[400],
            onPressed: () async {
              try {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020, 8),
                  lastDate: DateTime(2030, 10),
                );
                if (date != null) controller.search(date, context);
              } catch (err) {
                debugPrint(err.toString());
              }
            },
            child: Center(
                child: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: Colors.white,
            )),
          ),
          extendBodyBehindAppBar: true,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Row(
                    children: [
                      Expanded(child: BackButton()),
                      Expanded(
                        flex: 4,
                        child: Text('Date Wise Attendance',
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: 'Questrial',
                              fontSize: 60.sp,
                            )),
                      ),
                      Row(
                        children: [
                          IconButton(
                            // padding: EdgeInsets.symmetric(horizontal: 20),
                            // splashColor: Colors.transparent,
                            // highlightColor: Colors.transparent,
                            icon: Icon(FontAwesomeIcons.sort),
                            onPressed: () {
                              controller.reverseAttnDateWise();
                            },
                          ),
                          IconButton(
                            // padding: EdgeInsets.symmetric(horizontal: 20),
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              controller.resetSearch();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    child: GetBuilder<DatewiseAttnController>(builder: (_) {
                      return FutureBuilder<String>(
                          future: controller.getStudentAttendance(),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: kLightgreen,
                              ));
                            } else if (snapshot.hasError ||
                                snapshot.data == null) {
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
                              children: [
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    // color: Colors.white,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check,
                                            color: kLightgreen,
                                          ),
                                          Text(
                                            'Present',
                                            style: TextStyle(
                                                fontFamily: 'Questrial',
                                                fontSize: 48.sp),
                                          ),
                                          SizedBox(
                                            width: 50.w,
                                          ),
                                          Icon(
                                            Icons.close,
                                            color: kLightred,
                                          ),
                                          Text(
                                            'Absent',
                                            style: TextStyle(
                                                fontFamily: 'Questrial',
                                                fontSize: 48.sp),
                                          ),
                                        ])),
                                Expanded(
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        controller: ScrollController(),
                                        itemCount: controller.isSearchOn
                                            ? controller.searchAttnData.length
                                            : controller
                                                .datewiseAttnData.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return AnimationConfiguration
                                              .staggeredList(
                                                  position: index,
                                                  duration: const Duration(
                                                      milliseconds: 375),
                                                  child: SlideAnimation(
                                                      verticalOffset: 80.0,
                                                      child: FadeInAnimation(
                                                          child: SubAttnCard(
                                                        subData: controller
                                                                .isSearchOn
                                                            ? controller
                                                                .searchAttnData[
                                                                    index]
                                                                .subData
                                                            : controller
                                                                .datewiseAttnData[
                                                                    index]
                                                                .subData,
                                                        date: controller
                                                                .isSearchOn
                                                            ? controller
                                                                .searchAttnData[
                                                                    index]
                                                                .date
                                                            : controller
                                                                .datewiseAttnData[
                                                                    index]
                                                                .date,
                                                      ))));
                                        }),
                                  ),
                                ),
                              ],
                            );
                          }));
                    }),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
