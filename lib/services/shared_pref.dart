import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  // Is Login prefrences
  bool get isLogin => _sharedPrefs?.getBool(_isLoginKey) ?? false;

  set isLogin(bool value) {
    _sharedPrefs?.setBool(_isLoginKey, value);
  }

  final String _isLoginKey = "isLogin";

  //Login details preferences

  //roll no
  String? get rollNo => _sharedPrefs?.getString(_rollNoKey);

  set rollNo(String? value) {
    if (value == null) {
      _sharedPrefs?.remove(_rollNoKey);
    } else {
      _sharedPrefs?.setString(_rollNoKey, value);
    }
  }

  final String _rollNoKey = "rollno";

//password
  String? get password => _sharedPrefs?.getString(_passwordKey);

  set password(String? value) {
    if (value == null) {
      _sharedPrefs?.remove(_passwordKey);
    } else {
      _sharedPrefs?.setString(_passwordKey, value);
    }
  }

  final String _passwordKey = "password";

//cookie
  String? get cookie => _sharedPrefs?.getString(_cookieKey);

  set cookie(String? value) {
    if (value == null) {
      _sharedPrefs?.remove(_cookieKey);
    } else {
      _sharedPrefs?.setString(_cookieKey, value);
    }
  }

  final String _cookieKey = "cookie";

//plum Url
  String? get plumUrl => _sharedPrefs?.getString(_plumUrlKey);

  set plumUrl(String? value) {
    if (value == null) {
      _sharedPrefs?.remove(_plumUrlKey);
    } else {
      _sharedPrefs?.setString(_plumUrlKey, value);
    }
  }

  final String _plumUrlKey = "plumUrl";
}
