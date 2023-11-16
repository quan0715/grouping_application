import 'package:flutter/material.dart';
import 'package:grouping_project/View/shared/components/state.dart';
import 'package:grouping_project/exceptions/auth_service_exceptions.dart';
import 'package:grouping_project/service/auth/account.dart';
// import 'package:grouping_project/service/auth/auth_helpers.dart';
// // import 'package:grouping_project/VM/state.dart';
// import 'package:grouping_project/service/auth/github_auth.dart';
// import 'package:grouping_project/service/auth/google_auth.dart';
// import 'package:grouping_project/service/auth/line_auth.dart';
// import 'package:grouping_project/service/auth/web_oauth2.dart';

class LoginModel {
  String email = "";
  String password = "";
  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool get isFormValid => isEmailValid && isPasswordValid;
  // final GitHubAuth githubAuth = GitHubAuth();
  // final GoogleAuth googleAuth = GoogleAuth();
  // final LineAuth lineAuth = LineAuth();
  // final AuthService authService = AuthService();

  set accountEmail(String value) {
    email = value;
  }

  set accountPassword(String value) {
    password = value;
  }

  Future<LoginState> passwordLogin(String email, String password) async {
    try {
      AccountAuth accountAuth = AccountAuth();
      await accountAuth.signIn(account: email, password: password);

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


  // Future<LoginState> thirdPartyLogin(AuthProvider provider) async {
  //   try {
  //     switch (provider) {
  //       case AuthProvider.google:
  //         googleAuth.initializeOauthPlatform();
  //         break;
  //       case AuthProvider.github:
  //         githubAuth.initializeOauthPlatform();
  //         break;
  //       case AuthProvider.line:
  //         lineAuth.initializeOauthPlatform();
  //         break;
  //       default:
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return LoginState.loginFail;
  //   }
  //   // debugPrint("login successfully");
  //   return LoginState.loginSuccess;
  // }
}
