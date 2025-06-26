
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_flutter/config/constants.dart';

class AuthLocalDataSource {


  final SharedPreferences sf;

  AuthLocalDataSource(this.sf);
  
  Future<void> saveAccessToken(String token) async {
    await sf.setString(Constants.accessTokenKey, token);
  }

  Future<String?> getAccessToken() async {
    return sf.getString(Constants.accessTokenKey);
  }

  Future<void> removeAccessToken() async {
    await sf.remove(Constants.accessTokenKey);
  }
}