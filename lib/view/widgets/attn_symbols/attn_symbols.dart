import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InitialsTextSymbol extends StatelessWidget {
  const InitialsTextSymbol({
    Key? key,
    required this.attnMark,
  }) : super(key: key);
  final String attnMark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
      decoration: ShapeDecoration(
        shape: StadiumBorder(
          side: BorderSide(width: 2, color: Colors.white),
        ),
      ),
      child: Text(
        attnMark,
        style: TextStyle(
            fontSize: 50.sp,
            color: Colors.white,
            fontFamily: 'Questrial',
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
