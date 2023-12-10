import 'package:grouping_project/auth/data/datasources/auth_remote_data_source.dart';
import 'package:grouping_project/auth/data/repositories/auth_repository_impl.dart';

import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/providers/message_service.dart';
import 'package:grouping_project/auth/data/datasources/auth_local_data_source.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/auth/domain/usecases/logout_usecase.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/user_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/user_remote_data_source.dart';
import 'package:grouping_project/space/data/repositories/user_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/space_profile_entity.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/usecases/get_current_user_usecase.dart';

class UserPageViewModel extends ChangeNotifier {
  UserPageViewModel({required this.tokenModel});
  int currentPageIndex = 0;
  AuthTokenModel tokenModel = AuthTokenModel(token: "", refresh: "");
  SpaceProfileEntity get selectedProfile => userProfiles.first;
  MessageService messageService = MessageService();
  UserEntity? currentUser;

  List<SpaceProfileEntity> get userProfiles => [
        UserSpaceProfileEntity(
            spaceName: "張百寬 的個人儀表板",
            spacePhotoPicPath: "",
            spaceColor: const Color(0xFF7D5800)),
        // GroupSpaceProfileEntity(spaceName: "張百寬 的個人儀表板", spacePhotoPicPath: "", spaceColor: const Color(0xFF006874)),
      ];

  List<SpaceProfileEntity> get workspaceProfiles => [
        GroupSpaceProfileEntity(
            spaceName: "張百寬 的 workspace",
            spacePhotoPicPath: "",
            spaceColor: const Color(0xFFBF5F07)),
        GroupSpaceProfileEntity(
            spaceName: "Grouping 專題小組",
            spacePhotoPicPath: "",
            spaceColor: const Color(0xFF006874)),
        GroupSpaceProfileEntity(
            spaceName: "SEP Group",
            spacePhotoPicPath: "",
            spaceColor: const Color(0xFF206FCC)),
      ];

  void updateCurrentIndex(int index) {
    // for mobile use
    currentPageIndex = index;
    notifyListeners();
  }

  Future getCurrentUser(int userId) async {
    debugPrint("UserPageViewModel getCurrentUser");
    GetCurrentUserUseCase getCurrentUserUseCase =
        GetCurrentUserUseCase(UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(token: tokenModel.token),
      localDataSource: UserLocalDataSourceImpl(),
    ));

    final failureOrUser = await getCurrentUserUseCase(userId);

    failureOrUser.fold(
        (failure) => messageService.addMessage(
            MessageData.error(message: failure.toString())), (user) {
      currentUser = user;
      debugPrint("UserPageViewModel getCurrentUser success");
      // print user data
      debugPrint(user.toString());
    });
  }

  Future<void> logout() async {
    LogOutUseCase logOutUseCase = LogOutUseCase(AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl(),
    ));
    await logOutUseCase.call();
  }

  Future<void> init() async {
    //TODO:init with
    debugPrint("UserPageViewModel init");
    await getCurrentUser(tokenModel.userId);
  }
}
