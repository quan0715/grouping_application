import 'package:flutter/foundation.dart';
import 'package:grouping_project/View/shared/components/state.dart';
import 'package:grouping_project/config/config.dart';
import 'package:grouping_project/model/auth/auth_model_lib.dart';
import 'package:grouping_project/service/auth/auth_helpers.dart';
import 'package:grouping_project/service/auth/oauth_base_service.dart';

class LoginViewModel extends ChangeNotifier {
  // final AuthService authService = AuthService();
  LoginModel passwordLoginModel = LoginModel();

  String get password => passwordLoginModel.password;
  String get email => passwordLoginModel.email;
  // bool get isEmailValid => passwordLoginModel.isEmailValid;
  // bool get isPasswordValid => passwordLoginModel.isPasswordValid;
  // bool get isFormValid => passwordLoginModel.isFormValid;

  bool isLoading = false;
  bool shouldShowWindow = false;
  late BaseOAuthService attemptedOauth;
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
    // debugPrint("登入測試");
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

  void getOAuthService(AuthProvider provider) {
    switch (provider) {
      case AuthProvider.google:
        attemptedOauth = BaseOAuthService(
            clientId: getAuthProviderKeyAndSecret(AuthProvider.google).$1,
            clientSecret: getAuthProviderKeyAndSecret(AuthProvider.google).$2,
            scopes: Config.googleScopes,
            authorizationEndpoint: Config.googleAuthEndpoint,
            tokenEndpoint: Config.googleTokenEndpoint,
            provider: AuthProvider.google,
            usePkce: true,
            useState: false);
        return;
      case AuthProvider.github:
        attemptedOauth = BaseOAuthService(
            clientId: getAuthProviderKeyAndSecret(AuthProvider.github).$1,
            clientSecret: getAuthProviderKeyAndSecret(AuthProvider.github).$2,
            scopes: Config.gitHubScopes,
            authorizationEndpoint: Config.gitHubAuthEndpoint,
            tokenEndpoint: Config.gitHubTokenEndpoint,
            provider: AuthProvider.github,
            usePkce: false,
            useState: false);
        return;
      case AuthProvider.line:
        attemptedOauth = BaseOAuthService(
            clientId: getAuthProviderKeyAndSecret(AuthProvider.line).$1,
            clientSecret: getAuthProviderKeyAndSecret(AuthProvider.line).$2,
            scopes: Config.lineScopes,
            authorizationEndpoint: Config.lineAuthEndPoint,
            tokenEndpoint: Config.lineTokenEndpoint,
            provider: AuthProvider.line,
            useState: true,
            usePkce: true);
        return;
      default:
        throw Exception("Provider not found");
    }
  }

  Future<void> onThirdPartyLogin(AuthProvider provider) async {
    getOAuthService(provider);
    await attemptedOauth.initialLoginFlow();
    isLoading = true;
    shouldShowWindow = true;
    notifyListeners();
  }

  // Future<void> onThirdPartyLogin(
  //     AuthProvider provider, BuildContext context) async {
  //   // debugPrint("登入測試");
  //   // debugPrint("Email: $email , Password: $password");
  //   try {
  //     isLoading = true;
  //     notifyListeners();
  //     // var result = await passwordLoginModel.thirdPartyLogin(provider);
  //     BaseOAuthService authService = getOAuthService(provider);
  //     await authService.initialLoginFlow();
  //     if (context.mounted) {
  //       await authService.showWindowAndListen(context);
  //     }
  //     // loginState = result;
  //     isLoading = false;
  //     // debugPrint(loginState.toString());
  //     notifyListeners();
  //   } catch (e) {
  //     // Handle any errors that occur during the login process
  //     debugPrint(e.toString());
  //     loginState = LoginState.loginFail;
  //     isLoading = false;
  //     notifyListeners();
  //   }
  //   // debugPrint(loginState.toString());
  // }

  Future isURLContainCode(Uri platformURI) async {
    try {
      if (kIsWeb && platformURI.queryParameters.containsKey('code')) {
        if (platformURI.queryParametersAll.containsKey('scope')) {
          getOAuthService(AuthProvider.google);
        } else if (platformURI.queryParametersAll.containsKey('state')) {
          getOAuthService(AuthProvider.line);
        } else {
          getOAuthService(AuthProvider.github);
        }
        await attemptedOauth.getAccessToken();
      }
    } catch (e) {
      debugPrint(e.toString());
      loginState = LoginState.loginFail;
    }
    return;
  }

  Future addCodeToStorage({required String code}) async {
    await StorageMethods.write(key: 'code', value: code);
  }
}
