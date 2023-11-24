import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginManager extends ChangeNotifier {
  
  bool _isLogin = false;
  bool get isLogin => _isLogin;
  String userAccessToken = '';

  Future<void> checkLoginState() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('auth-token');
    if(token != null){
      userAccessToken = token;
      _isLogin = true;
    }else{
      _isLogin = false;
    }
    notifyListeners();
  }
}