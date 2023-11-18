class LoginEntity {
  String _email = "";
  String _password = "";
  
  bool get isFormValid => isEmailValid && isPasswordValid;
  bool get isEmailValid => _email.isNotEmpty;
  bool get isPasswordValid => _password.isNotEmpty;
  String get email => _email;
  String get password => _password;

  set accountEmail(String value) => _email = value;
  set accountPassword(String value) => _password = value;


  // Future<LoginState> passwordLogin(String email, String password) async {
  //   try {
  //     AccountAuth accountAuth = AccountAuth();
  //     await accountAuth.signIn(account: email, password: password);
  //     return LoginState.loginSuccess;
  //   } catch (error) {
  //     // debugPrint('In func. passwordLogin: $error');
  //     switch ((error as AuthServiceException).code) {
  //       case 'wrong_password':
  //         debugPrint('wrong_password');
  //         return LoginState.wrongPassword;
  //       case 'user_does_not_exist':
  //         debugPrint('user_does_not_exist');
  //         return LoginState.userNotFound;
  //       default:
  //         debugPrint(error.toString());
  //         return LoginState.loginFail;
  //     }
  //   }
  // }
}
