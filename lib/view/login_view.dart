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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: Get.find<LoginController>(),
        builder: (controller) {
          if (controller.isLoading == true) {
            return Scaffold(
              backgroundColor: Color(0xFF212D49),
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
                      color: Colors.white,
                      fontFamily: 'Questrial',
                    ),
                  ),
                ),
                body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 70.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 200.w,
                          backgroundImage: AssetImage('images/nsut_logo.png')),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text('IMS',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 100.sp,
                          )),
                      Spacer(
                        flex: 1,
                      ),
                      FutureBuilder<String?>(
                          future: controller.getCaptcha(),
                          builder: ((context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == null) {
                              return CircularProgressIndicator();
                            }

                            return CachedNetworkImage(
                              imageUrl: snapshot.data!,
                              httpHeaders: const {
                                "Referer":
                                    "https://www.imsnsit.org/imsnsit/student.php",
                                "User-Agent":
                                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36",
                                "Host": "imsnsit.org",
                              },
                            );
                          })),
                      Spacer(
                        flex: 1,
                      ),
                      LoginTextFormField(
                        keyboardType: TextInputType.text,
                        isEnable: true,
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
                      SizedBox(
                        height: 30.h,
                      ),
                      LoginTextFormField(
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
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LoginTextFormField(
                            prefix: Icons.password,
                            controller: controller.captchaController,
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
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forget Password?',
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontFamily: 'Questrial',
                                  fontSize: 50.sp),
                            ),
                          ),
                        ],
                      ),
                      Text(controller.msg ?? '',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 55.sp,
                          )),
                      SizedBox(
                        height: 30.h,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: kLightgreen,
                          ),
                          onPressed: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.login();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Questrial',
                                  fontSize: 50.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
