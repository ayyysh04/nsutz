import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:nsutz/controller/login_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:nsutz/view/widgets/login_text_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);
//TODO: improve login page for responsivnes ,refer flutterfore login page with size resizable and debig on redmi note 4
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: Get.find<LoginController>(),
        builder: (controller) {
          if (controller.isLoading == true) {
            return Scaffold(
              body: Center(
                  child: Wrap(
                children: const [
                  Center(
                      child: Text(
                    'Logging you in...',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Questrial',
                        fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: 30,
                  ),
                  SpinKitRing(
                    color: Colors.white,
                    size: 100.0,
                  ),
                ],
              )),
            );
          }
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Form(
              key: controller.formKey,
              child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    elevation: 0,
                    title: Text(
                      'NSUT Attendance',
                      style: TextStyle(
                        fontFamily: 'Questrial',
                        fontSize: 60.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  body: SafeArea(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 70.w) //full view padding
                        ,
                        child: Stack(
                            alignment: AlignmentDirectional.center,
                            fit: StackFit.expand,
                            children: [
                              Positioned(
                                top: 0.h,
                                child: Column(children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 200.w,
                                      backgroundImage:
                                          AssetImage('images/nsut_logo.png')),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text('UMS',
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontFamily: 'Questrial',
                                        letterSpacing: 2.0,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 100.sp,
                                      )),
                                ]),
                              ),
                              Positioned(
                                bottom:
                                    (MediaQuery.of(context).viewInsets.bottom !=
                                            0)
                                        ? controller.captchaNoFocusNode.hasFocus
                                            ? 580.h
                                            : 240.h
                                        : 1200.h,
                                left: 0,
                                right: 0,
                                child: LoginTextFormField(
                                  focusNode: controller.rollNoFocusNode,
                                  isObscureText: false,
                                  keyboardType: TextInputType.text,
                                  isEnable:
                                      true, //true:makes keyboard cursor and soft keyboard  enable
                                  prefix: Icons.perm_identity_rounded,
                                  controller: controller.rollNoController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Roll no is required!';
                                    }
                                    if (value.length < 11) {
                                      return 'Invalid Roll No';
                                    }
                                    return null;
                                  },
                                  labelText: "NSUT ROLL NO",
                                ),
                              ),
                              Positioned(
                                //220
                                bottom:
                                    (MediaQuery.of(context).viewInsets.bottom !=
                                            0)
                                        ? controller.captchaNoFocusNode.hasFocus
                                            ? 370.h
                                            : 15.h
                                        : 980.h,
                                left: 0.w,
                                right: 0.w,
                                child: LoginTextFormField(
                                  isObscureText: true,
                                  keyboardType: TextInputType.text,
                                  isEnable: true,
                                  prefix: Icons.password,
                                  controller: controller.passController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required!';
                                    }
                                    return null;
                                  },
                                  labelText: 'PASSWORD',
                                  focusNode: controller.passFocusNode,
                                ),
                              ),
                              Visibility(
                                visible: !(MediaQuery.of(context)
                                            .viewInsets
                                            .bottom !=
                                        0 &&
                                    (controller.rollNoFocusNode.hasFocus ||
                                        controller.passFocusNode.hasFocus)),
                                child: Positioned(
                                  bottom: (MediaQuery.of(context)
                                              .viewInsets
                                              .bottom !=
                                          0)
                                      ? 15.h
                                      : 620.h,
                                  left: 0.w,
                                  right: 0.w,
                                  child: Column(
                                    children: [
                                      FutureBuilder<String?>(
                                          future: controller.getCaptcha(),
                                          builder: ((context, snapshot) {
                                            if (!snapshot.hasData ||
                                                snapshot.data == null) {
                                              return CircularProgressIndicator();
                                            }
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  height: 150.h,
                                                  width: 320.w,
                                                  fit: BoxFit.contain,
                                                  imageUrl: snapshot.data!,
                                                  httpHeaders: const {
                                                    "Referer":
                                                        "https://www.imsnsit.org/imsnsit/student.php",
                                                    "User-Agent":
                                                        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36",
                                                    "Host": "imsnsit.org",
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 20.w,
                                                ),
                                                GestureDetector(
                                                  onTap:
                                                      controller.reloadCaptcha,
                                                  child: Icon(
                                                    Icons.refresh,
                                                    size: 100.w,
                                                  ),
                                                ),
                                              ],
                                            );
                                          })),
                                      Visibility(
                                        visible: controller.msg != null,
                                        child: Text(controller.msg ?? '',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 55.sp,
                                            )),
                                      ),
                                      SizedBox(height: 20.h),
                                      LoginTextFormField(
                                        isObscureText: false,
                                        prefix: Icons.password,
                                        controller:
                                            controller.captchaController,
                                        labelText: 'CAPTCHA',
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Captcha is required!';
                                          } else if (value.length != 5) {
                                            return 'Invalid Captcha';
                                          }
                                          return null;
                                        },
                                        isEnable: true,
                                        keyboardType: TextInputType.number,
                                        focusNode:
                                            controller.captchaNoFocusNode,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   bottom: 500.h,
                              //   left: 0.w,
                              //   right: 0.w,
                              //   child:
                              // ),
                              Positioned(
                                top: 1600.h,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: kLightgreen,
                                    ),
                                    onPressed: () {
                                      if (controller.formKey.currentState!
                                          .validate()) {
                                        controller.login();
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Questrial',
                                            fontSize: 50.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              )
                            ])),
                  )),
            ),
          );
        });
  }
}
