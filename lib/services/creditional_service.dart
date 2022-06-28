//Stores Creditional related data and Creditional fetching services
import 'package:nsutz/model/credentials_model.dart';

class CreditionalSerivce {
  Credentials credentialsData = Credentials();

  set rollNo(String? val) {
    credentialsData.rollno = val;
  }

  set password(String? val) {
    credentialsData.password = val;
  }

  String? get rollNo => credentialsData.rollno;
  String? get password => credentialsData.password;
}
