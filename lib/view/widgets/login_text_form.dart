import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginTextFormField extends StatelessWidget {
  const LoginTextFormField(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.validator,
      required this.prefix,
      required this.isEnable,
      required this.keyboardType})
      : super(key: key);
  final bool isEnable;
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final IconData prefix;
  final TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      showCursor: isEnable,
      readOnly: !isEnable,
      controller: controller,
      validator: validator,
      style: TextStyle(
          color: Colors.white, fontFamily: 'Questrial', fontSize: 55.sp),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(25.0),
        ),
        prefixIcon: Icon(
          prefix,
          color: Colors.white,
          size: 60.sp,
        ),
        // disabledBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: Colors.white),
        //     borderRadius: BorderRadius.circular(20)),
        labelText: labelText,

        labelStyle: TextStyle(color: Colors.white),
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
