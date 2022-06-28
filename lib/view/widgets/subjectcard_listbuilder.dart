import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsutz/controller/dashboard_controller.dart';
import 'package:nsutz/view/widgets/subject_card.dart';

class SubjectCardListBuilder extends GetView<DashboardController> {
  // final void Function() onTapCardFunction;
  // final List<AttendanceModel> subjectdata;

  const SubjectCardListBuilder({
    // required this.subjectdata,
    Key? key,
    // required this.onTapCardFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ScrollController(),
      physics: BouncingScrollPhysics(),
      itemCount: controller.attnData.length,
      itemBuilder: (context, itemNo) {
        var subjectItem = controller.attnData[itemNo];

        return GestureDetector(
          onTap: () => controller.openSubdayWise(
              subjectItem.subjectCode!, subjectItem.overallPercentage!),
          child: SubjectsCard(
              percent: subjectItem.overallPercentage!,
              subject: subjectItem.subjectCode!),
        );
      },
    );
  }
}
