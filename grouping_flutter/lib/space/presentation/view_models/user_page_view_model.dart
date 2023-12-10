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
        debugPrint("UserPageViewModel getCurrentUser success: ${user.toString()}");
        // notifyListeners();
      }
    );
  }

  Future<void> userLogout() async {
    final logOutUseCase = LogOutUseCase(authRepositoryImpl);
    await logOutUseCase.call();
  } 

  SpaceProfileEntity getUserProfile(){
    return UserSpaceProfileEntity(
      spaceName: currentUser?.name ?? "name",
      spacePhotoPicPath: "",
      spaceColor: AppColor.mainSpaceColor
    );
  }

  List<SpaceProfileEntity> getWorkspaceList() {
    // display workspace list in drawer and switch workspace frame
    // return await userRepositoryImpl.getWorkspaceList();
    return (currentUser?.joinedWorkspaces ?? []).map<SpaceProfileEntity>(
      (workspace) => GroupSpaceProfileEntity(
        spaceName: workspace.name,
        spacePhotoPicPath: "",
        spaceColor: AppColor.getWorkspaceColorByIndex(workspace.themeColor)
    )).toList();
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

  bool get isLoading => _isLoading;
  
  UserEntity? get currentUser => userDataProvider!.currentUser;

  List<SpaceProfileEntity> get userProfiles => [
    userDataProvider!.getUserProfile()
  ];
  

  SpaceProfileEntity get selectedProfile => userProfiles.first;

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
    // debugPrint(userDataProvider!.currentUser.toString());
    // notifyListeners();
  }

}
