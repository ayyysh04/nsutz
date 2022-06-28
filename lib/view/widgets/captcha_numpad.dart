import 'package:flutter/material.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaptchaNumpad extends StatelessWidget {
  final double buttonHeightSize = 170.h;
  final double buttonWidthSize = 220.w;
  final TextEditingController pinController;
  final Function onChange;
  final Function onSubmit;

  CaptchaNumpad({
    Key? key,
    required this.pinController,
    required this.onChange,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 100.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonWidget('1'),
                buttonWidget('2'),
                buttonWidget('3'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonWidget('4'),
                buttonWidget('5'),
                buttonWidget('6'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonWidget('7'),
                buttonWidget('8'),
                buttonWidget('9'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                iconButtonWidget(Icons.backspace, () {
                  if (pinController.text.isNotEmpty) {
                    pinController.text = pinController.text
                        .substring(0, pinController.text.length - 1);
                  }
                }, kLightred),
                buttonWidget('0'),
                iconButtonWidget(Icons.check_circle, () {
                  onSubmit(pinController.text);
                }, kLightgreen)
              ],
            ),
          ],
        ),
      ),
    );
  }

  buttonWidget(String buttonText) {
    return SizedBox(
      height: 170.h,
      width: 220.w,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: kCardbackgroundcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonWidthSize / 4),
          ),

          // focusColor: Colors.blue,
          // hoverColor: Colors.blue,
          // highlightColor: Colors.blue,
        ),
        onPressed: () {
          //allow only 6 digit pins
          if (pinController.text.length == 5) {
            return;
          }
          pinController.text = pinController.text + buttonText;
          onChange(pinController.text);
        },
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
                fontFamily: 'Questrial'),
          ),
        ),
      ),
    );
  }

  iconButtonWidget(IconData icon, void Function() function, Color color) {
    return InkWell(
      onTap: function,
      child: SizedBox(
        height: buttonHeightSize,
        width: buttonWidthSize,
        // decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
