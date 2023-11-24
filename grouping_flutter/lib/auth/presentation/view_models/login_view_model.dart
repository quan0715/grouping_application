import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grouping_project/app/presentation/providers/message_service.dart';
import 'package:grouping_project/auth/data/datasources/auth_local_data_source.dart';
import 'package:grouping_project/auth/data/datasources/auth_remote_data_source.dart';
import 'package:grouping_project/auth/data/repositories/auth_repository_impl.dart';
import 'package:grouping_project/auth/domain/entities/login_entity.dart';
import 'package:grouping_project/auth/domain/usecases/login_usecase.dart';
import 'package:grouping_project/auth/utils/auth_provider_enum.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
import 'package:grouping_project/core/config/config.dart';
import 'package:grouping_project/auth/utils/auth_helpers.dart';
import 'package:grouping_project/auth/utils/oauth_base_service.dart';

class LoginViewModel extends ChangeNotifier {
  // final AuthService authService = AuthService();
  LoginEntity passwordLoginEntity = LoginEntity();
  MessageService messageService = MessageService();
  AuthRepositoryImpl repo = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl());
  bool shouldShowWindow = false;
  late BaseOAuthService attemptedOauth;
  String get password => passwordLoginEntity.password;
  String get email => passwordLoginEntity.email;

  String userAccessToken = "";

  bool isLoading = false;
  // LoginState loginState = LoginState.loginFail;

  void updateEmail(String value) {
    passwordLoginEntity.accountEmail = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    passwordLoginEntity.accountPassword = value;
    notifyListeners();
  }

  String? emailValidator(value) {
    return email.isNotEmpty ? null : "信箱不得為空";
  }

  String? passwordValidator(value) {
    return password.length >= 6 ? null : "密碼過短";
  }

  Future<void> onPasswordLogin() async {
    debugPrint("Login with: Email: $email , Password: $password");

    PasswordLoginUseCase passwordLoginUseCase =
        PasswordLoginUseCase(repository: repo);
    userAccessToken = "";
    isLoading = true;
    notifyListeners();
    final failureOrAuthToken =
        await passwordLoginUseCase.call(passwordLoginEntity);
    failureOrAuthToken.fold((failure) {
      debugPrint(failure.errorMessage);
      messageService.addMessage(
          MessageData.error(title: "登入失敗", message: failure.errorMessage));
    }, (authToken) {
      userAccessToken = authToken.token;
      debugPrint("access token : $userAccessToken");
    });
    isLoading = false;
    notifyListeners();
  }

  Future<void> init() async {
    messageService.clearMessages();
    await repo.localDataSource.clearCacheToken();
    passwordLoginEntity.accountEmail = "123123123";
    passwordLoginEntity.accountPassword = "123123123";
    notifyListeners();
    return;
  }

  BaseOAuthService getOAuthService(AuthProvider provider) {
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
        return attemptedOauth;
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
        return attemptedOauth;
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
        return attemptedOauth;
      default:
        throw Exception("Provider not found");
    }
  }

  Future<void> onThirdPartyLogin(AuthProvider provider) async {
    // debugPrint("登入測試");
    // debugPrint("Email: $email , Password: $password");
    try {
      isLoading = true;
      BaseOAuthService authService = getOAuthService(provider);
      await authService.initialLoginFlow();
      shouldShowWindow = true;

      notifyListeners();
    } catch (e) {
      // Handle any errors that occur during the login process
      debugPrint(e.toString());
      // loginState = LoginState.loginFail;
      isLoading = false;
      notifyListeners();
    }
    // debugPrint(loginState.toString());
  }

  Future isURLContainCode(Uri platformURI) async {
    if (kIsWeb && platformURI.queryParameters.containsKey('code')) {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage.write(key: 'code', value: Uri.base.queryParameters['code']);
      BaseOAuthService authService;
      if (platformURI.queryParametersAll.containsKey('scope')) {
        authService = getOAuthService(AuthProvider.google);
      } else if (platformURI.queryParametersAll.containsKey('state')) {
        authService = getOAuthService(AuthProvider.line);
      } else {
        authService = getOAuthService(AuthProvider.github);
      }
      await authService.getAccessToken();
    }
    return;
  }

  Future addCodeToStorage({required String code}) async {
    await StorageMethods.write(key: 'code', value: code);
  }
}
