import 'package:get/get_utils/get_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nsutz/model/attendance_model.dart';
import 'package:nsutz/model/student_model.dart';

class HiveService {
  Box<Student>? profileDataBox;
  Box<AttendanceModelSubWise>? attnDataBox;
  Future<void> init() async {
    try {
      await Hive.initFlutter();
    } catch (e) {
      printError(info: e.toString());
    }
    profileDataBox = await Hive.openBox<Student>('profileData');
    attnDataBox = await Hive.openBox('attnData');
  }
}
