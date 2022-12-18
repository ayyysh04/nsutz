import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:nsutz/controller/notice_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:nsutz/view/widgets/search_text_form.dart';

class NoticeView extends GetView<NoticeController> {
  const NoticeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => controller.searchFocusNode.unfocus()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: kBackgroundcolor,
          elevation: 0.0,
          title: Text(
            "Notice and Circulars",
            style: TextStyle(
              fontFamily: 'Questrial',
              fontSize: 60.sp,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: Icon(
                  Icons.search,
                  size: 30.0,
                ),
                onTap: () => controller.showSearchBar(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: Icon(
                  Icons.refresh,
                  size: 30.0,
                ),
                onTap: controller.refreshNotice,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GetBuilder<NoticeController>(
                    id: controller.searchTag,
                    builder: (_) {
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 345),
                        transitionBuilder: (child, animation) {
                          return SlideTransition(
                            position: animation.drive(
                              Tween(
                                begin: Offset(0, -1),
                                end: Offset(0, 0),
                              ),
                            ),
                            child: child,
                          );
                        },
                        child: controller.searchQuery != null
                            ? SearchTextFormField(
                                searchTextController:
                                    controller.searchTextController,
                                searchFocusNode: controller.searchFocusNode)
                            : SizedBox(),
                      );
                    }),
                //all notice cards
                Expanded(
                  flex: 9,
                  child: GetBuilder<NoticeController>(
                      id: controller.noticeTag,
                      builder: (_) {
                        return FutureBuilder<String?>(
                            future: controller.getNotices(),
                            builder: ((context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: kLightgreen,
                                ));
                              } else if (snapshot.data != null &&
                                  controller.notices.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No Notice to fetch!',
                                    style: TextStyle(
                                      fontSize: 50.sp,
                                      fontFamily: 'Questrial',
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError ||
                                  snapshot.data == null) {
                                return Center(
                                  child: Text(
                                    'Error! Press Refresh to load + ${snapshot.data}' //TODO: make this more cleaner
                                    ,
                                    style: TextStyle(
                                      fontSize: 50.sp,
                                      fontFamily: 'Questrial',
                                    ),
                                  ),
                                );
                              }
                              return NoticeCardListBuilder();
                            }));
                      }),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo[400],
                  ),
                  onPressed: controller.getOldNotice,
                  child: Text(
                    'View Old Notices',
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 50.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoticeCardListBuilder extends GetView<NoticeController> {
  const NoticeCardListBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AnimationLimiter(
            child: ListView.separated(
              controller: ScrollController(),
              physics: BouncingScrollPhysics(),
              itemCount: controller.searchQuery != null
                  ? (controller.searchNotices.length + 1)
                  : (controller.notices.length +
                      1), //one extra item for first heading
              itemBuilder: (context, tempItem) {
                if (tempItem == 0) return Container();
                var itemNo = tempItem - 1;
                var noticeItem = controller.searchQuery == null
                    ? controller.notices[itemNo]
                    : controller.searchNotices[itemNo];

                return AnimationConfiguration.staggeredList(
                    position: itemNo,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                        verticalOffset: 44.0,
                        child: FadeInAnimation(
                            child: GestureDetector(
                                onTap: () => controller.openNotice(context,
                                    notice: noticeItem.notice,
                                    link: noticeItem.url,
                                    date: noticeItem.date),
                                child: NoticeCard(
                                  publishedBy: noticeItem.publishedBy,
                                  notice: noticeItem.notice,
                                  date: noticeItem.date,
                                )))));
              },
              separatorBuilder: (BuildContext context, int itemNo) {
                bool isWithDate = false;
                if (itemNo == 0) {
                  isWithDate = true;
                } else if (controller.searchQuery == null &&
                    (controller.notices[itemNo].date !=
                        controller.notices[itemNo - 1].date)) {
                  isWithDate = true;
                } else if (controller.searchQuery != null &&
                    (controller.searchNotices[itemNo].date !=
                        controller.searchNotices[itemNo - 1].date)) {
                  isWithDate = true;
                } else {
                  isWithDate = false;
                }
                return isWithDate
                    ? Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Divider(
                                thickness: 2,
                                color: Colors.grey[300],
                              )),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            controller.searchQuery == null
                                ? toStringDate(controller.notices[itemNo].date)
                                : toStringDate(
                                    controller.searchNotices[itemNo].date),
                            style: TextStyle(
                              fontSize: 45.sp,
                              fontFamily: 'Questrial',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            flex: 20,
                            child: Divider(
                              thickness: 2,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      )
                    : Container();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class NoticeCard extends StatelessWidget {
  const NoticeCard({
    Key? key,
    required this.notice,
    required this.date,
    required this.publishedBy,
  }) : super(key: key);
  final String notice;
  final DateTime date;
  final String publishedBy;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 15.w),
      color: kCardbackgroundcolor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(55.w),
      ),
      elevation: 6.0,
      child: Container(
        // height: 340.h,
        padding: EdgeInsets.symmetric(horizontal: 65.w, vertical: 50.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              notice,
              style: TextStyle(
                fontSize: 45.sp,
                fontFamily: 'Questrial',
                // fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Published By:" + publishedBy,
              style: TextStyle(
                fontSize: 35.sp,
                fontFamily: 'Questrial',
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
