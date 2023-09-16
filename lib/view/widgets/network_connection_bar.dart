import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nsutz/services/connection_check_service.dart';
import 'package:nsutz/services/session_service.dart';

class NetworkConnectivityBar extends StatelessWidget {
  NetworkConnectivityBar({
    Key? key,
  }) : super(key: key);

  final _connectionSerivce = Get.find<NetworkConnectivityService>();
  final _sessionSerive = Get.find<SessionSerivce>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _connectionSerivce.connectionStream,
      initialData: _connectionSerivce.isOnline,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return AnimatedContainer(
            clipBehavior: Clip.antiAlias,
            width: double.infinity,
            height: !snapshot.data!
                ? 80.h
                : _sessionSerive.isSessionUpdated
                    ? 0
                    : 80.h,
            color: snapshot.data! ? Colors.green[400] : Colors.red,
            duration: Duration(milliseconds: 700),
            child: Center(
                child: snapshot.data!
                    ? _sessionSerive.isSessionUpdated
                        ? Text("Back online")
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Updating Session Data"),
                              SizedBox(width: 20.h),
                              SizedBox(
                                  height: 50.h,
                                  width: 50.h,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.0))
                            ],
                          )
                    : Text("No Internet Connection")));
      },
    );
  }
}
