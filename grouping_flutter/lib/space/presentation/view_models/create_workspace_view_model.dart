import 'package:flutter/material.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/workspace_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/workspace_remote_data_source.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/data/repositories/workspace_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/create_workspace_usecase.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/join_worksapcee_usecase.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/workspace_usecaes_lib.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:image_picker/image_picker.dart';

class CreateWorkspaceViewModel extends ChangeNotifier {

  UserDataProvider? userDataProvider;
  WorkspaceEntity newWorkspaceData = WorkspaceEntity.newWorkspace();
  XFile? tempAvatarFile;

  String tag = "";
  
  List<Color> spaceColors = AppColor.spaceColors;

  Color get spaceColor => AppColor.getWorkspaceColorByIndex(newWorkspaceData.themeColor);

  void clearTag(){
    tag = "";
    notifyListeners();
  }
  void deleteTag(int index) {
    newWorkspaceData.tags.removeAt(index);
    notifyListeners();
  }

  void addTag() {
    // newWorkspaceData.tags.add(WorkspaceTagModel(content: tag));
    if(tag.isNotEmpty){
      newWorkspaceData.tags.add(WorkspaceTagModel(content: tag));
      clearTag();
    }
    notifyListeners();
  }
  
  set spaceColorIndex(int index) {
    newWorkspaceData.themeColor = index;
    notifyListeners();
  }

  set spaceName(String name) {
    newWorkspaceData.name = name;
    notifyListeners();
  }

  set spaceDescription(String description) {
    newWorkspaceData.description = description;
    notifyListeners();
  }

  set updateProfileData(XFile? file){
    tempAvatarFile = file;
    notifyListeners();
  }

  Future<void> createWorkspace() async {

    debugPrint(newWorkspaceData.toString());
    var workspaceRepo = WorkspaceRepositoryImpl(
      remoteDataSource: WorkspaceRemoteDataSourceImpl(token: userDataProvider!.tokenModel.token),
      localDataSource: WorkspaceLocalDataSourceImpl()
    );

    final createWorkspaceUseCase = CreateCurrentWorkspaceUseCase(workspaceRepo);
    final joinWorkspaceUseCase = JoinWorkspaceUseCase(workspaceRepo);

    final workspaceOrFailure = await createWorkspaceUseCase(
      creator: userDataProvider!.currentUser!,
      entity: newWorkspaceData,
      image: tempAvatarFile,  
    );
    bool isSuccess = false;

    workspaceOrFailure.fold(
      (failure) => {
        debugPrint('create workspace failure: $failure')
      },
      (workspace) => {
        newWorkspaceData = workspace,
        isSuccess = true,
        debugPrint('create workspace success: $newWorkspaceData'),
      },
    );
    
    if(!isSuccess){
      return;
    }

    var joinOrFailure = await joinWorkspaceUseCase(newWorkspaceData, userDataProvider!.currentUser!);

    joinOrFailure.fold(
      (failure) => debugPrint('join workspace failure: $failure'),
      (workspace) => {
        newWorkspaceData = workspace,
        debugPrint('update workspace success: $newWorkspaceData'),
      },
    );

    await userDataProvider!.updateUser();
    notifyListeners();
  }

  void update(UserDataProvider userDataProvider) {
    this.userDataProvider = userDataProvider;
    newWorkspaceData = WorkspaceEntity.newWorkspace();
    notifyListeners();
  }
}