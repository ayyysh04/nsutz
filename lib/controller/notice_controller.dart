import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/model/notice_model.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/nsutapi.dart';

class NoticeController extends GetxController {
  final NsutApi _nsutApi = Get.find<NsutApi>();
  List<NoticeModel> notices = [];
  bool oldNotice = false;
  Future<String> getNotices() async {
    if (notices.isEmpty) {
      CustomResponse<List<NoticeModel>>? res;
      if (oldNotice == false) {
        res = await _nsutApi.getNotices();
      } else {
        res = await _nsutApi.getOldNotices();
      }
      if (res.data == null || res.error != null) {
        return res.error!;
      } else {
        notices = res.data!;
      }
    }
    return "success";
  }

  void refreshNotice() async {
    notices = [];
    update();
  }

  void getOldNotice() async {
    notices = [];
    oldNotice = true;
    update();
  }

  void openNotice(BuildContext context,
      {required String notice, String? link, required String date}) {
    var headers = {
      "Referer": "https://www.imsnsit.org/imsnsit/",
      "Content-Type": "application/x-www-form-urlencoded",
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36",
      "Origin": "imsnsit.org",
      "Host": "www.imsnsit.org",
    };
    Get.toNamed(Routes.PDF,
        arguments: {"url": link, "headers": headers, "notice": notice});
  }
}
