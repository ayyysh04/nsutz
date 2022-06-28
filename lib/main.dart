import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nsutz/routes/routes.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/binding.dart';
import 'package:nsutz/theme/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {});

  runApp(ScreenUtilInit(
      designSize: Size(1080, 2340), builder: (_, __) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.SPLASH,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: appThemeData,
      getPages: RoutePages.pages,
    );
  }
}
