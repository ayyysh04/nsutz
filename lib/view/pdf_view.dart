import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nsutz/theme/constants.dart';

class PDFViewer extends StatelessWidget {
  const PDFViewer({
    Key? key,
    required this.url,
    required this.notice,
    required this.headers,
  }) : super(key: key);

  final String url;
  final String notice;

  final Map<String, String> headers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: kBackgroundcolor,
        child: Icon(
          Icons.save_alt_rounded,
          color: Colors.white,
        ),
        onPressed: (() async {
          //TODO:IMPLEMENT SAVE LOGIC USING FOLDER PICKUP PLUGIN
          // await File(cacheLoc).rename(
          //     '/storage/emulated/0/Urfolder'); //changes file location to a new loc
        }),
      ),
      appBar: AppBar(
        title: Text(notice),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: PDF().cachedFromUrl(
        url,
        headers: headers,
        whenDone: (cacheLoc) {},
        maxAgeCacheObject: Duration(days: 1),
        placeholder: (double progress) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 30.h,
              ),
              Text('$progress %'),
            ],
          ),
        ),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
