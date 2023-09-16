import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/model/custom_response.dart';
import 'package:nsutz/model/notice_model.dart';
import 'package:nsutz/routes/routes_const.dart';
import 'package:nsutz/services/nsutapi.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeController extends GetxController {
  //services
  final NsutApi _nsutApi = Get.find<NsutApi>();

  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  String? searchQuery;
  List<NoticeModel> notices = [];
  List<NoticeModel> searchNotices = [];
  bool oldNotice = false;

  String searchTag = 'searchTag';

  String noticeTag = 'noticeTag';
  Future<bool> getNotices() async {
    if (notices.isEmpty) {
      CustomResponse<List<NoticeModel>>? noticeRes;
      if (oldNotice == false) {
        noticeRes = await _nsutApi.getNotices();
      } else {
        noticeRes = await _nsutApi.getOldNotices();
      }
      if (noticeRes.res != Result.success) {
        return false;
      }
      notices = noticeRes.data!;
    }
    return true;
  }

  void refreshNotice() async {
    notices = [];
    update([noticeTag]);
  }

  void getOldNotice() async {
    notices = [];
    oldNotice = true;
    update([noticeTag]);
  }

  void openNotice(BuildContext context,
      {required String notice, String? link, required DateTime date}) async {
    if (link != null) {
      var headers = {
        "Referer": "https://www.imsnsit.org/imsnsit/",
        "Content-Type": "application/x-www-form-urlencoded",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36",
        "Origin": "imsnsit.org",
        "Host": "www.imsnsit.org",
      };
      if (link.contains("drive")) {
        Uri url = Uri.parse(link);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $url';
        }
      } else {
        Get.toNamed(Routes.PDF,
            arguments: {"url": link, "headers": headers, "notice": notice});
      }
    }
  }

  void showSearchBar() {
    searchQuery = '';
    searchFocusNode.requestFocus();
    if (searchQuery == '') {
      update([noticeTag]);
    }
    update([searchTag]);
  }

  void closeSearchBar() {
    searchTextController.clear();
    searchNotices.clear();
    searchQuery = null;
    searchFocusNode.unfocus();
    update([searchTag, noticeTag]);
  }

  void showSearchResult(String text) {
    searchNotices.clear();
    searchQuery = text;
    if (searchQuery != '') {
      searchNotices.addAll(notices.where((element) =>
          element.date.toString().contains(text.toLowerCase()) ||
          element.publishedBy.toLowerCase().contains(text.toLowerCase()) ||
          element.notice.toLowerCase().contains(text.toLowerCase())));
    }
    // TODO:use a seprator search controller if possible
    update([noticeTag]);
  }
}
