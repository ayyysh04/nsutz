import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nsutz/theme/constants.dart';

class SubAttnCard extends StatelessWidget {
  const SubAttnCard({Key? key, required this.subAttnData}) : super(key: key);
  final Map subAttnData;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      color: kCardbackgroundcolor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(color: Color(0x90758AA7), width: 1.5),
      ),
      elevation: 6.0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 10.w),
        child: Column(
          children: <Widget>[
            //Date heading
            Text(
              subAttnData['date'].toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Questrial',
                  letterSpacing: 1.1,
                  fontSize: 50.sp),
            ),
            //attendance body
            subjectHeadingBuilder(subAttnData['attn'] as List)
          ],
        ),
      ),
    );
  }

  Widget subjectHeadingBuilder(List allSubAttn) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: allSubAttn.length,
        padding: EdgeInsets.symmetric(vertical: 25.h),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          String heading = allSubAttn[index].keys.first;
          String value = allSubAttn[index].values.first;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  heading,
                  softWrap: true,
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontFamily: 'Questrial',
                  ),
                ),
                (value == 'P')
                    ? Icon(
                        Icons.check,
                        color: kLightgreen,
                      )
                    : Icon(
                        Icons.close,
                        color: kLightred,
                      ),
              ],
            ),
          );
        });
  }
}
