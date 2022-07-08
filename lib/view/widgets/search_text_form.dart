import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nsutz/controller/notice_controller.dart';

class SearchTextFormField extends GetView<NoticeController> {
  const SearchTextFormField({
    Key? key,
    required this.searchTextController,
    required this.searchFocusNode,
  }) : super(key: key);

  final TextEditingController searchTextController;
  final FocusNode searchFocusNode;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: TextField(
        controller: searchTextController,
        onChanged: controller.showSearchResult,
        onTap: () {
          controller.showSearchBar();
        },
        focusNode: searchFocusNode,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: searchFocusNode.hasFocus ? Colors.black : Colors.grey[600],
            ),
            suffixIcon: GestureDetector(
              child: Icon(
                Icons.close,
                color:
                    searchFocusNode.hasFocus ? Colors.black : Colors.grey[600],
              ),
              onTap: () {
                controller.closeSearchBar();
              },
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(15.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(15.0),
            ),
            filled: true,
            hintStyle: TextStyle(
              fontFamily: 'Questrial',
              fontSize: 50.sp,
              color: searchFocusNode.hasFocus ? Colors.black : Colors.grey[600],
            ),
            hintText: "Search notices",
            fillColor: Colors.grey[200]),
        style: TextStyle(
          fontFamily: 'Questrial',
          fontSize: 50.sp,
          color: searchFocusNode.hasFocus ? Colors.black : Colors.grey[600],
        ),
      ),
    );
  }
}
