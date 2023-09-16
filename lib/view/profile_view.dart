// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:nsutz/controller/studentprofile_controller.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:nsutz/utility/date_function.dart';

class StudentProfileView extends GetView<StudentProfileCotnroller> {
  const StudentProfileView({Key? key}) : super(key: key);

  String getth(int n) {
    if (n == 1)
      return 'st';
    else if (n == 2)
      return 'nd';
    else if (n == 3)
      return 'rd';
    else
      return 'th';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Questrial',
            fontSize: 60.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 60.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(50.w),
                  child: Image.memory(
                      controller.studentProfileData.studentImage!)),
              Divider(
                thickness: 2.0,
                color: kCardbackgroundcolor,
              ),
              Expanded(
                flex: 4,
                child: ListView(
                  controller: ScrollController(keepScrollOffset: false),
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  children: [
                    UserCards(
                      icon: Icons.perm_identity,
                      name: controller.studentProfileData.studentName,
                      colour: kLightgreen,
                    ),
                    UserCards(
                      icon: Icons.cake_rounded,
                      name: dobToString(
                          controller.studentProfileData.studentDOB!),
                      colour: kLightgreen,
                    ),
                    UserCards(
                      icon: Icons.verified_user,
                      name: controller.studentProfileData.studentID,
                      colour: kLightgreen,
                    ),
                    UserCards(
                      icon: Icons.school,
                      name: controller.studentProfileData.studentDegree! +
                          " - "
                              "${controller.studentProfileData.studentCurrentSemester!}${getth(controller.studentProfileData.studentCurrentSemester!)} Semester",
                      colour: kLightgreen,
                    ),
                    UserCards(
                      icon: Icons.menu_book,
                      name: controller.studentProfileData.studentBranchName! +
                          " - " +
                          controller.studentProfileData.studentSection!,
                      colour: kLightgreen,
                    ),
                    Visibility(
                      visible:
                          controller.studentProfileData.studentSpecialization !=
                              controller.studentProfileData.studentBranchName,
                      child: UserCards(
                        icon: Icons.menu_book,
                        name:
                            controller.studentProfileData.studentSpecialization,
                        colour: kLightgreen,
                      ),
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                    MaterialButton(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 30.h, horizontal: 100.w),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            color: kLightred,
                            fontFamily: 'Questrial',
                            fontSize: 50.sp,
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: kLightred, width: 2.0)),
                      ),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: kBackgroundcolor,
                                title: Text(
                                  "Logout of App?",
                                  textAlign: TextAlign.center,
                                ),
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: kLightblue,
                                      ),
                                      child: Text(
                                        "Cancel",
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: kLightblue),
                                      child: Text("LogOut"),
                                      onPressed: () async {
                                        await controller.logout();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      splashColor: Color(0x50FF606F),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async => controller.openlinkedinProfile(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.link,
                      color: kLightYellow,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      'Developed by Ayush Yadav',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: 'Questrial',
                        color: kLightYellow,
                        fontSize: 50.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCards extends StatelessWidget {
  const UserCards({
    Key? key,
    this.icon,
    this.name,
    this.colour,
  }) : super(key: key);
  final IconData? icon;
  final String? name;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 40.w),
      child: Row(
        children: [
          Icon(
            icon,
            color: colour,
            size: 70.w,
          ),
          SizedBox(width: 30.w),
          Expanded(
            child: Text(
              '$name',
              maxLines: 2,
              style: TextStyle(
                fontSize: 55.sp,
                color: colour,
                fontFamily: 'Questrial',
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: kCardbackgroundcolor, width: 2.0)),
    );
  }
}
