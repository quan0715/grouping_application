import 'package:grouping_project/auth/utils/auth_provider_enum.dart';

class CodeEntity {
  String code = "";
  AuthProvider authProvider;

  CodeEntity({
    this.code = "",
    this.authProvider = AuthProvider.account,
  });

  void updateCode(String value) => code = value;

  void updateProvider(AuthProvider value) => authProvider = value;
}
