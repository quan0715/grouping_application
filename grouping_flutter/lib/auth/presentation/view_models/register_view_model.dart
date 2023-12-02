import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/providers/message_service.dart';
import 'package:grouping_project/auth/data/datasources/auth_local_data_source.dart';
import 'package:grouping_project/auth/data/datasources/auth_remote_data_source.dart';
import 'package:grouping_project/auth/data/repositories/auth_repository_impl.dart';
import 'package:grouping_project/auth/domain/entities/register_entity.dart';
import 'package:grouping_project/auth/domain/usecases/register_usecase.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class RegisterViewModel extends ChangeNotifier {
  MessageService messageService = MessageService();
  RegisterEntity registerEntity = RegisterEntity();
  AuthRepositoryImpl repo = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(),
    localDataSource: AuthLocalDataSourceImpl()
  );

  String get password => registerEntity.password;
  String get passwordConfirm => registerEntity.passwordConfirm;
  String get userName => registerEntity.userName;
  String get email => registerEntity.email;
  String userAccessToken = "";
  // bool get isPasswordValid => passwordRegisterModel.isPasswordValid;
  // bool get isPasswordConfirmValid => passwordRegisterModel.isPasswordConfirmValid;
  // bool get isUserNameValid => passwordRegisterModel.isUserNameValid;
  bool isLoading = false;

  void onEmailChange(String value) {
    registerEntity.updateEmail(value);
    notifyListeners();
  }

  void onUserNameChange(String value) {
    registerEntity.updateUserName(value);
    notifyListeners();
  }

  void onPasswordChange(String value) {
    registerEntity.updatePassword(value);
    notifyListeners();
  }
  void onPasswordConfirmChange(String value) {
    registerEntity.updatePasswordConfirm(value);
    notifyListeners();
  }

  String? emailValidator(value) => email.isNotEmpty ? null : "請輸入有效電子郵件";
  
  String? userNameValidator(value) => userName.isNotEmpty ? null : "請填入使用者名稱";  

  String? passwordValidator(value) => password.length >= 6 ? null : "密碼長度禁止低於6";
  
  String? passwordConfirmValidator(value) => 
    passwordConfirm.length >= 6 
      ? passwordConfirm == password ? null : "兩次輸入密碼不吻合"
      : "密碼長度禁止低於6";

  Future<void> register() async {
    isLoading = true;
    notifyListeners();
    debugPrint("註冊新使用者 : 帳號 $userName , 密碼 $password , 電子郵件 $email}");
    final userRegisterUseCase = UserRegisterUseCase(repository: repo);
    final failureOrAuthToken = await userRegisterUseCase.call(registerEntity);
    failureOrAuthToken.fold(
      (failure){
        debugPrint(failure.errorMessage);
        messageService.addMessage(MessageData.error(title: "註冊失敗", message: failure.errorMessage));
      },
      (authToken){
        userAccessToken = authToken.token;
        debugPrint("access token : $userAccessToken");
        messageService.addMessage(MessageData.success(title: "註冊成功", message: "正在前往使用者頁面"));
      }
    );
    isLoading = false;
    notifyListeners();
  }

  Future init() async {
    messageService.clearMessages();
    await repo.localDataSource.clearCacheToken();
    notifyListeners();
    return ;
  }
}
