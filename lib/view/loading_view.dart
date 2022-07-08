import 'package:flutter/material.dart';
import 'package:nsutz/theme/constants.dart';
import 'package:shimmer/shimmer.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  Future<bool> load() async {
    await Future.delayed(Duration(seconds: 5));
    return true;
    try {
      // await
      // TO asyn work here
      //when done push to dashboard
    } catch (err) {
      //if error push to login/captcha again
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool?>(
          future: load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          width: 200.0,
                          color: kCardbackgroundcolor,
                        ),
                      ),
                      Container(
                        height: 20.0,
                        width: 300,
                        margin: EdgeInsets.only(bottom: 10.0),
                        color: kCardbackgroundcolor,
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Center(
                            //TODO:loading page not in use ,remove it or use it
                            child: Text(
                              'Fetching Attendance form Accsoft...',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Questrial',
                                fontSize: 17.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: kCardbackgroundcolor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: kCardbackgroundcolor,
                          ),
                        ),
                      ),
                      Container(
                        height: 35.0,
                        width: double.infinity,
                        color: kCardbackgroundcolor,
                        margin: EdgeInsets.only(bottom: 30.0),
                      ),
                      Container(
                        height: 20.0,
                        width: 300,
                        margin: EdgeInsets.only(bottom: 10.0),
                        color: kCardbackgroundcolor,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: kCardbackgroundcolor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: kCardbackgroundcolor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                baseColor: kCardbackgroundcolor,
                highlightColor: Color(0xff758AA7),
              );
            } else
              return Container();
          }),
    );
  }
}
