import 'package:flutter/material.dart';
import 'package:grouping_project/View/components/state.dart';
import 'package:grouping_project/exceptions/auth_service_exceptions.dart';
import 'package:grouping_project/service/auth/auth_service.dart';
// import 'package:grouping_project/VM/state.dart';

class LoginModel {
  String email = "";
  String password = "";

  set accountEmail(String value) {
    email = value;
  }

  set accountPassword(String value) {
    password = value;
  }

  Future<LoginState> passwordLogin(String email, String password) async {
    try {
      // TODO: add email login method
      AuthService authService = AuthService();
      await authService.signIn(account: email, password: password);

      return LoginState.loginSuccess;
    } catch (error) {
      // debugPrint('In func. passwordLogin: $error');
      switch ((error as AuthServiceException).code) {
        case 'wrong_password':
          debugPrint('wrong_password');
          return LoginState.wrongPassword;
        case 'user_does_not_exist':
          debugPrint('user_does_not_exist');
          return LoginState.userNotFound;
        default:
          debugPrint(error.toString());
          return LoginState.loginFail;
      }
    }
  }

  Future<LoginState> thirdPartyLogin(
      AuthProvider provider, BuildContext context) async {
    try {
      AuthService authService = AuthService();
      await authService.thridPartyLogin(provider, context);
      // TODO: add email login method
    } catch (e) {
      debugPrint(e.toString());
      return LoginState.loginFail;
    }
    // debugPrint("login successfully");
    return LoginState.loginSuccess;
  }
}
