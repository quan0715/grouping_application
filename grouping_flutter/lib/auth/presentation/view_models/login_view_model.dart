import 'package:flutter/foundation.dart';

import 'package:grouping_project/app/presentation/providers/message_service.dart';
import 'package:grouping_project/auth/data/datasources/auth_local_data_source.dart';
import 'package:grouping_project/auth/data/datasources/auth_remote_data_source.dart';
import 'package:grouping_project/auth/data/repositories/auth_repository_impl.dart';
import 'package:grouping_project/auth/domain/entities/code_entity.dart';
import 'package:grouping_project/auth/domain/entities/login_entity.dart';
import 'package:grouping_project/auth/domain/usecases/login_usecase.dart';
import 'package:grouping_project/auth/utils/auth_provider_enum.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
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
    final failureOrAuthToken = await passwordLoginUseCase(passwordLoginEntity);

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
    passwordLoginEntity.accountEmail = "quanquan";
    passwordLoginEntity.accountPassword = "123123123";
    notifyListeners();
    return;
  }

  Future<void> onThirdPartyLogin(AuthProvider provider) async {
    AuthLocalDataSourceImpl().clearCacheToken();
    try {
      isLoading = true;
      attemptedOauth = BaseOAuthService.getOAuthService(provider);
      await attemptedOauth.initialLoginFlow();
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
    late final CodeEntity codeEntity;
    if (kIsWeb && platformURI.queryParameters.containsKey('code')) {
      if (platformURI.queryParametersAll.containsKey('scope')) {
        codeEntity = CodeEntity(
            code: Uri.base.queryParameters['code']!,
            authProvider: AuthProvider.google);
      } else if (platformURI.queryParametersAll.containsKey('state')) {
        codeEntity = CodeEntity(
            code: Uri.base.queryParameters['code']!,
            authProvider: AuthProvider.line);
      } else {
        codeEntity = CodeEntity(
            code: Uri.base.queryParameters['code']!,
            authProvider: AuthProvider.github);
      }
      var failureOrToken = await repo.thridPartyExchangeToken(codeEntity);

      failureOrToken.fold((failure) {
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
    return;
  }
}
