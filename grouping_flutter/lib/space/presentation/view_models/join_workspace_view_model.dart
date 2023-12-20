import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/providers/message_service.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/workspace_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/workspace_remote_data_source.dart';
import 'package:grouping_project/space/data/repositories/workspace_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/get_current_workspace_usecase.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/join_worksapcee_usecase.dart';
import 'package:grouping_project/space/presentation/view_models/user_data_provider.dart';
import 'package:image_picker/image_picker.dart';

class JoinWorkspaceViewModel extends ChangeNotifier {


  MessageService messageService = MessageService();
  String _workspaceIndex = '';
  UserDataProvider? userDataProvider;
  WorkspaceEntity? joinedWorkspace;
  XFile? tempAvatarFile;
  Uint8List? tempAvatarBytes;

  String get workspaceIndex => _workspaceIndex;

  Color get spaceColor => userDataProvider!.currentUser!.spaceColor;

  Color get workspaceColor => AppColor.getWorkspaceColorByIndex(
    joinedWorkspace?.themeColor ?? 0
  );

  void clearWorkspaceIndex(){
    _workspaceIndex = '';
    notifyListeners();
  }

  set workspaceIndex(String index) {
    _workspaceIndex = index;
    notifyListeners();
  }


  Future<void> getWorkspace() async {
    debugPrint('getWorkspace $workspaceIndex');
    final getWorkspaceUseCase = GetWorkspaceUseCase(
      WorkspaceRepositoryImpl(
        remoteDataSource: WorkspaceRemoteDataSourceImpl(
          token: userDataProvider!.tokenModel.token,
        ),
        localDataSource: WorkspaceLocalDataSourceImpl(),
      ),
    );

    final failureOrWorkspace = await getWorkspaceUseCase(
      int.parse(_workspaceIndex),
    );

    failureOrWorkspace.fold(
      (failure) => {
        messageService.addMessage(
          MessageData.error(
            title: '搜尋失敗',
            message: failure.errorMessage,
          ),
        ),
        joinedWorkspace = null,
      },
      (workspace) {
        joinedWorkspace = workspace;
        debugPrint('joinedWorkspace: ${joinedWorkspace.toString()}');
        notifyListeners();
      },
    );
  }

  Future<bool> joinWorkspace() async {
    debugPrint('getWorkspace $workspaceIndex');
    if(joinedWorkspace != null){
      final updateCurrentWorkspaceUseCase = JoinWorkspaceUseCase(
        WorkspaceRepositoryImpl(
        remoteDataSource: WorkspaceRemoteDataSourceImpl(
          token: userDataProvider!.tokenModel.token,
        ),
        localDataSource: WorkspaceLocalDataSourceImpl(),
      ),);

      final failureOrWorkspace = await updateCurrentWorkspaceUseCase(
        joinedWorkspace!, userDataProvider!.currentUser!,
      );

      failureOrWorkspace.fold(
        (failure) => {
          messageService.addMessage(
            MessageData.error(
              title: '加入失敗',
              message: failure.errorMessage,
            ),
          )
        },
        (workspace) async {
          joinedWorkspace = workspace;
          await userDataProvider!.updateUser();
          debugPrint('joinedWorkspace: ${joinedWorkspace.toString()}');
          notifyListeners();
        },
      );
      return true;
    }
    
    return false;
  }



  void update(UserDataProvider userDataProvider) {
    this.userDataProvider = userDataProvider;
    notifyListeners();
  }
}