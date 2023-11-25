import 'package:flutter/material.dart';
import 'package:grouping_project/auth/data/datasources/auth_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/user_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/user_remote_data_source.dart';
import 'package:grouping_project/space/data/repositories/user_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/space_profile_entity.dart';
import 'package:grouping_project/space/domain/usecases/get_current_user_usecase.dart';

class UserPageViewModel extends ChangeNotifier{
  int currentPageIndex = 0;


  SpaceProfileEntity get selectedProfile => userProfiles.first;

  List<SpaceProfileEntity> get userProfiles => [
    UserSpaceProfileEntity(spaceName: "張百寬 的個人儀表板", spacePhotoPicPath: "",spaceColor: const Color(0xFF7D5800)),
  ];

  List<SpaceProfileEntity> get workspaceProfiles => [
    GroupSpaceProfileEntity(spaceName: "張百寬 的 workspace", spacePhotoPicPath: "", spaceColor: const Color(0xFFBF5F07)),
    GroupSpaceProfileEntity(spaceName: "Grouping 專題小組", spacePhotoPicPath: "", spaceColor: const Color(0xFF006874)),
    GroupSpaceProfileEntity(spaceName: "SEP Group", spacePhotoPicPath: "", spaceColor: const Color(0xFF206FCC)),
  ];

  void updateCurrentIndex(int index){
    currentPageIndex = index;
    notifyListeners();
  }

  Future<String> getAccessToken() async{
    debugPrint("UserPageViewModel getAccessToken");
    AuthLocalDataSource authLocalDataSource = AuthLocalDataSourceImpl();
    // AuthLocalDataSource authLocalDataSource = AuthLocalDataSource();
    final token = await authLocalDataSource.getCacheToken();
    return token.token ;
  }

  Future getCurrentUser(int userId) async{
    debugPrint("UserPageViewModel getCurrentUser");
    GetCurrentUserUseCase getCurrentUserUseCase = GetCurrentUserUseCase(UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(token: await getAccessToken()),
      localDataSource: UserLocalDataSource(),
    ));
    await getCurrentUserUseCase(userId);
  }

  Future<void> init() async{
    debugPrint("UserPageViewModel init");
    await getCurrentUser(5);
  }
}