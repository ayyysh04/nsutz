import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nsutz/controller/datewiseattn_controller.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nsutz/view/widgets/subattncard_builder.dart';

class DatewiseAttnView extends GetView<DatewiseAttnController> {
  const DatewiseAttnView({Key? key}) : super(key: key);

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
                  firstDate: DateTime(2019, 8),
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
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                'Date Wise Attendance',
              ),
              actions: <Widget>[
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
              ]),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      // color: Colors.white,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              color: kLightgreen,
                            ),
                            Text(
                              'Present',
                              style: TextStyle(
                                  fontFamily: 'Questrial', fontSize: 48.sp),
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
                                  fontFamily: 'Questrial', fontSize: 48.sp),
                            ),
                          ])),
                  GetBuilder<DatewiseAttnController>(builder: (_) {
                    return Expanded(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: ScrollController(),
                          itemCount: controller.attnData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SubAttnCard(
                              subAttnData: controller.attnData[index],
                            );
                          }),
                    );
                  }),
                ],
              ),
            ),
          )),
    );
  }
}
