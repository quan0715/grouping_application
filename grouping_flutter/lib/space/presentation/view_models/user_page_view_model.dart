import 'package:grouping_project/auth/data/datasources/auth_remote_data_source.dart';
import 'package:grouping_project/auth/data/repositories/auth_repository_impl.dart';

import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/providers/message_service.dart';
import 'package:grouping_project/auth/data/datasources/auth_local_data_source.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/auth/domain/usecases/logout_usecase.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/user_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/user_remote_data_source.dart';
import 'package:grouping_project/space/data/repositories/user_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/space_profile_entity.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/usecases/get_current_user_usecase.dart';
import 'package:grouping_project/space/domain/usecases/update_current_user.dart';


class UserDataProvider extends ChangeNotifier{
  final AuthTokenModel tokenModel;
  final MessageService? messageService;
  final UserRepositoryImpl userRepositoryImpl;
  bool isLoading = false;
  final AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(),
    localDataSource: AuthLocalDataSourceImpl(),
  );

  UserDataProvider({
    required this.tokenModel,
    this.messageService,
  }):
    userRepositoryImpl = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(token: tokenModel.token),
      localDataSource: UserLocalDataSourceImpl(),
    );

  UserEntity? currentUser;

  Future<void> getCurrentUser(int userId) async {
    // debugPrint("UserPageViewModel getCurrentUser");
    final getCurrentUserUseCase = GetCurrentUserUseCase(userRepositoryImpl);

    final failureOrUser = await getCurrentUserUseCase(userId);

    failureOrUser.fold(
      (failure) {
        debugPrint("UserPageViewModel getCurrentUser failure: ${failure.toString()}");
        messageService?.addMessage(
          MessageData.error(message: failure.toString())
        );
      },
      (user) {
        currentUser = user;
        // debugPrint("UserPageViewModel getCurrentUser success: ${user.toString()}");
        //
      }
    );
    notifyListeners();
  }

  Future<void> userLogout() async {
    final logOutUseCase = LogOutUseCase(authRepositoryImpl);
    await logOutUseCase();
  } 

  SpaceProfileEntity getUserProfile(){
    return UserSpaceProfileEntity(
      spaceName: currentUser?.name ?? "name",
      spacePhotoPicPath: "",
      spaceColor: AppColor.mainSpaceColor
    );
  }

  

  Future<void> updateUser() async{

    var updateUserUseCase = UpdateUserUseCase(userRepositoryImpl);
    isLoading = true;

    final failureOrUser = await updateUserUseCase(currentUser!);

    failureOrUser.fold(
      (failure){
        debugPrint(failure.toString());
      },
      (user) {
        debugPrint("update user success");
        debugPrint(user.toString());
        currentUser = user;
      }
    );
    isLoading = false;
    notifyListeners();

  }

  Future<void> init() async {
    isLoading = true;
    // notifyListeners();
    await getCurrentUser(tokenModel.userId);
    isLoading = false;
    // notifyListeners();
    // debugPrint("UserData init, ${currentUser?.toString()}");
  }
}

class UserSpaceViewModel extends ChangeNotifier {

  final messageService = MessageService();
  UserDataProvider? userDataProvider;
  
  bool _isLoading = true;

  bool get isLoading => _isLoading || userDataProvider!.isLoading;
  
  UserEntity? get currentUser => userDataProvider!.currentUser;

  final Color spaceColor = AppColor.spaceColor2;

  Future<void> init() async {
    debugPrint("UserPageViewModel init");
    _isLoading = true;
    notifyListeners();
    await userDataProvider!.init();
    _isLoading = false;
    notifyListeners();
  }

  void update(UserDataProvider userProvider) {
    debugPrint("UserViewModel update userData");
    userDataProvider = userProvider;
    notifyListeners();
  }

}
