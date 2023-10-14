import 'package:flutter/material.dart';
import 'package:grouping_project/View/components/state.dart';
import 'package:grouping_project/model/auth/auth_model_lib.dart';
import 'package:grouping_project/service/auth/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  // final AuthService authService = AuthService();
  LoginModel passwordLoginModel = LoginModel();

  String get password => passwordLoginModel.password;
  String get email => passwordLoginModel.email;
  // bool get isEmailValid => passwordLoginModel.isEmailValid;
  // bool get isPasswordValid => passwordLoginModel.isPasswordValid;
  // bool get isFormValid => passwordLoginModel.isFormValid;

  bool isLoading = false;
  LoginState loginState = LoginState.loginFail;

  void updateEmail(String value) {
    passwordLoginModel.accountEmail = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    passwordLoginModel.password = value;
    // debugPrint("Password: $value");
    notifyListeners();
  }

  String? emailValidator(value) {
    return email.isNotEmpty ? null : "信箱不得為空";
  }

  String? passwordValidator(value) {
    return password.length >= 6 ? null : "密碼過短";
  }

  Future<void> onFormPasswordLogin() async {
    debugPrint("登入測試");
    debugPrint("Email: $email , Password: $password");
    try {
      isLoading = true;
      notifyListeners();
      var result = await passwordLoginModel.passwordLogin(email, password);
      loginState = result;
      isLoading = false;
      debugPrint(loginState.toString());
      notifyListeners();
    } catch (e) {
      // Handle any errors that occur during the login process
      debugPrint(e.toString());
      loginState = LoginState.loginFail;
      isLoading = false;
      notifyListeners();
    }
    // debugPrint(loginState.toString());
  }

  Future<void> onThirdPartyLogin(
      AuthProvider provider, BuildContext context) async {
    // debugPrint("登入測試");
    // debugPrint("Email: $email , Password: $password");
    try {
      isLoading = true;
      notifyListeners();
      var result = await passwordLoginModel.thirdPartyLogin(provider, context);
      loginState = result;
      isLoading = false;
      // debugPrint(loginState.toString());
      notifyListeners();
    } catch (e) {
      // Handle any errors that occur during the login process
      debugPrint(e.toString());
      loginState = LoginState.loginFail;
      isLoading = false;
      notifyListeners();
    }
    // debugPrint(loginState.toString());
  }
}
