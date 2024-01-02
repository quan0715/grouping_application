import 'package:flutter/material.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/workspace_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/workspace_remote_data_source.dart';
import 'package:grouping_project/space/data/repositories/workspace_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/workspace_usecaes_lib.dart';

class GroupDataProvider extends ChangeNotifier {
  GroupDataProvider({required this.tokenModel, required this.workspaceIndex});

  final AuthTokenModel tokenModel;

  int workspaceIndex = -1;
  WorkspaceEntity? currentWorkspace;

  bool isLoading = false;

  // final MessageService? messageService;

  Color get color => AppColor.getWorkspaceColorByIndex(
    currentWorkspace!.themeColor,
  );

  Future getWorkspace() async {
    debugPrint("WorkspaceViewModel getCurrentWorkspace");

    GetWorkspaceUseCase getCurrentWorkspaceUseCase =
        GetWorkspaceUseCase(WorkspaceRepositoryImpl(
      remoteDataSource:
          WorkspaceRemoteDataSourceImpl(token: tokenModel.token),
      localDataSource: WorkspaceLocalDataSourceImpl(),
    ));

    if(workspaceIndex == -1){
      throw Exception("workspaceIndex is not set");
    }
    final failureOrWorkspace = await getCurrentWorkspaceUseCase(workspaceIndex);

    failureOrWorkspace.fold(
      (failure) => {
        debugPrint("WorkspaceViewModel getCurrentWorkspace failure: ${failure.toString()}")
      },
      (workspace) {
      currentWorkspace = workspace;
      debugPrint("WorkspaceViewModel getCurrentWorkspace success");
      // print user data
      debugPrint(workspace.toString());
      }
    );
    notifyListeners();
  }

  Future<void> init() async {
    isLoading = true;
    await getWorkspace();
    isLoading = false;
    // debugPrint("UserData init, ${currentUser?.toString()}");
  }

}
