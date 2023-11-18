
class RegisterEntity {
  String userName = "";
  String email = "";
  String password = "";
  String passwordConfirm = "";
  
  RegisterEntity({
    this.userName = "",
    this.email = "",
    this.password = "",
    this.passwordConfirm = "",
  });

  void updateEmail(String value)  => email = value;
  
  void updatePasswordConfirm(String value) => passwordConfirm = value;

  void updateUserName(String value) => userName = value;
  
  void updatePassword(String value) => password = value;
}
