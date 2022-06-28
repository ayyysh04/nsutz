import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.checkLoginAndNavigate(),
        builder: (context, snapshot) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.yellow,
          );
        });
  }
}
