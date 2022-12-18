import 'package:get/get.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/binding.dart';
import 'package:nsutz/view/captcha_view.dart';
import 'package:nsutz/view/dashboard_view.dart';
import 'package:nsutz/view/datewiseattn_view.dart';
import 'package:nsutz/view/loading_view.dart';
import 'package:nsutz/view/login_view.dart';
import 'package:nsutz/view/notice_view.dart';
import 'package:nsutz/view/pdf_view.dart';
import 'package:nsutz/view/profile_view.dart';
import 'package:nsutz/view/splash_view.dart';
import 'package:nsutz/view/subjectwiseattn_view.dart';

class RoutePages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
        name: Routes.CAPTCHA,
        page: () => CaptchaView(),
        binding: CaptchaBinding()),
    GetPage(
        name: Routes.DASHBOARD,
        page: () => DashboardView(),
        binding: DashboardBinding()),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.DATEWISEATTN,
      page: () => DatewiseAttnView(),
      binding: DatewiseAttnBinding(),
    ),
    GetPage(
      name: Routes.STUPROFILE,
      page: () => StudentProfileView(),
      binding: StudentProfileBinding(),
    ),
    GetPage(
      name: Routes.NOTICE,
      page: () => NoticeView(),
      binding: NoticeBinding(),
    ),
    GetPage(
      name: Routes.PDF,
      page: () {
        return PDFViewer(
          url: Get.arguments["url"],
          headers: Get.arguments["headers"],
          notice: Get.arguments["notice"],
        );
      },
      binding: NoticeBinding(),
    ),
    GetPage(
      name: Routes.SUBWISEATTN,
      page: () {
        return SubjectWiseAttnView(
          subjectCode: Get.arguments["subCode"],
          subjectName: Get.arguments["subName"],
        );
      },
      binding: SubjectWiseAttnBinding(),
    ),
  ];
}
