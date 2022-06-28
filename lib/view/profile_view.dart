import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nsutz/controller/studentprofile_controller.dart';
import 'package:nsutz/theme/constants.dart';

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
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 60.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 150.w,
                  child: controller.studentProfileData.studentImage),
              Container(
                width: double.infinity,
                height: 2.0,
                margin: EdgeInsets.symmetric(vertical: 60.h),
                color: kCardbackgroundcolor,
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      UserCards(
                        icon: Icons.perm_identity,
                        name: controller.studentProfileData.studentName,
                        colour: kLightgreen,
                      ),
                      UserCards(
                        icon: Icons.verified_user,
                        name: controller.studentProfileData.studentID,
                        colour: kLightYellow,
                      ),
                      UserCards(
                        icon: Icons.school,
                        name: controller.studentProfileData.studentDegree,
                        colour: kLightred,
                      ),
                      UserCards(
                        icon: Icons.menu_book,
                        name:
                            "${controller.studentProfileData.studentCurrentSemester!}${getth(controller.studentProfileData.studentCurrentSemester!)} Semester",
                        colour: Colors.white70,
                      ),
                      UserCards(
                        icon: Icons.menu_book,
                        name: controller.studentProfileData.studentBranchName,
                        colour: kLightYellow,
                      ),
                      SizedBox(
                        height: 100.h,
                      ),
                      Flexible(
                        child: MaterialButton(
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
                                border:
                                    Border.all(color: kLightred, width: 2.0)),
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
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Uri url = Uri.parse(
                      'https://www.linkedin.com/in/ayush-yadav-6a712421a/');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
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
                    Flexible(
                      child: Text(
                        'Developed by Ayush Yadav',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Questrial',
                          color: kLightYellow,
                          fontSize: 50.sp,
                        ),
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
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            icon,
            color: colour,
            size: 60.sp,
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
