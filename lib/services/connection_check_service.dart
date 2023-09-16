import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkConnectivityService {
  final _networkConnectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();
  bool isOnline = false;
  Stream<bool> get connectionStream => _controller.stream;

  Future<void> initialise() async {
    await _checkStatus();
    _networkConnectivity.onConnectivityChanged.listen((result) async {
      await _checkStatus();
    });
  }

  Future<void> _checkStatus() async {
    // try {
    // final result = await InternetAddress.lookup('www.google.com');
    isOnline = await InternetConnectionChecker().hasConnection;
    // isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    // } on SocketException catch (_) {
    //   isOnline = false;
    // }
    printInfo(info: isOnline.toString());
    _controller.sink.add(isOnline);
  }

  void disposeStream() => _controller.close();

  void rebuildConnectionStatusBar() {
    _controller.sink.add(isOnline);
  }
}
