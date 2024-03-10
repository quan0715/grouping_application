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
}
