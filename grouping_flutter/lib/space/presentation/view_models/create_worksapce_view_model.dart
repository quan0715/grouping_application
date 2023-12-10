import 'package:flutter/material.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/workspace_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/workspace_remote_data_source.dart';
import 'package:grouping_project/space/data/repositories/workspace_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/create_workspace_usecase.dart';

class CreateWorkspaceViewModel extends ChangeNotifier {

  CreateWorkspaceViewModel(
    this.tokenModel,
  );

  final AuthTokenModel tokenModel;
  
  final WorkspaceEntity _workspaceEntity = WorkspaceEntity(
    id: -1, 
    themeColor: 0, 
    name: 'test', 
    description: 'test', 
    photo: null, 
    members: [], 
    activities: [], 
    tags: [
      "test1",
      "test2",
    ]
  );

  Future<void> createWorkspace() async {
    final createCurrentWorkspaceUseCase = CreateCurrentWorkspaceUseCase(
      WorkspaceRepositoryImpl(
        remoteDataSource: WorkspaceRemoteDataSourceImpl(token: tokenModel.token),
        localDataSource: WorkspaceLocalDataSourceImpl()
      ) 
    );
    final workspaceOrFailure = await createCurrentWorkspaceUseCase(_workspaceEntity);
    workspaceOrFailure.fold(
      (failure) => debugPrint('create workspace failure: $failure'),
      (workspace) => debugPrint('create workspace success: ${workspace.toString()}'),
    );
    notifyListeners();
  }
}