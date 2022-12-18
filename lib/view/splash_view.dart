import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/controller/splash_controller.dart';
import 'package:nsutz/theme/constants.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundcolor,
      child: SafeArea(
          child: Center(
        child: FutureBuilder(
            future: controller.checkUserDataAndNavigate(),
            builder: ((context, snapshot) => CircularProgressIndicator())),
      )),
    );
  }
}
