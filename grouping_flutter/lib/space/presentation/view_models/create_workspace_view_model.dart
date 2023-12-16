import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/workspace_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/workspace_remote_data_source.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/data/repositories/workspace_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/create_workspace_usecase.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/workspace_usecaes_lib.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:image_picker/image_picker.dart';

class CreateWorkspaceViewModel extends ChangeNotifier {

  UserDataProvider? userDataProvider;
  WorkspaceEntity newWorkspaceData = WorkspaceEntity.newWorkspace();
  XFile? tempAvatarFile;
  Uint8List? tempAvatarBytes;

  String tag = "";
  
  List<Color> spaceColors = [
    AppColor.mainSpaceColor,
    AppColor.spaceColor1,
    AppColor.spaceColor2,
    AppColor.spaceColor3,
    AppColor.spaceColor4,
  ];

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

  Future<void> createWorkspace() async {

    debugPrint(newWorkspaceData.toString());
    var workspaceRepo = WorkspaceRepositoryImpl(
      remoteDataSource: WorkspaceRemoteDataSourceImpl(token: userDataProvider!.tokenModel.token),
      localDataSource: WorkspaceLocalDataSourceImpl()
    );

    final createCurrentWorkspaceUseCase = CreateCurrentWorkspaceUseCase(workspaceRepo);
    final updateCurrentWorkspaceUseCase = UpdateCurrentWorkspaceUseCase(workspaceRepo);

    final workspaceOrFailure = await createCurrentWorkspaceUseCase(newWorkspaceData, tempAvatarFile);

    workspaceOrFailure.fold(
      (failure) => debugPrint('create workspace failure: $failure'),
      (workspace) => {
        newWorkspaceData = workspace,
        debugPrint('create workspace success: $newWorkspaceData'),
      },
    );

    newWorkspaceData.members.add(Member(
      id: userDataProvider!.currentUser!.id ?? -1,
      photo: null,
      userName: userDataProvider!.currentUser!.name,  
    ));

    var updateOrFailure = await updateCurrentWorkspaceUseCase(newWorkspaceData);
    updateOrFailure.fold(
      (failure) => debugPrint('update workspace failure: $failure'),
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

  Future<void> updateProfileData(XFile file) async {
    tempAvatarFile = file;
    tempAvatarBytes = await file.readAsBytes();
    notifyListeners();
  }
}