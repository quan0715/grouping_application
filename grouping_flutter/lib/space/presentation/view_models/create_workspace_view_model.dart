import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/providers/message_service.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/workspace_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/workspace_remote_data_source.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/data/repositories/workspace_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/create_workspace_usecase.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/join_worksapcee_usecase.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/workspace_usecaes_lib.dart';
import 'package:grouping_project/space/presentation/provider/user_data_provider.dart';
import 'package:image_picker/image_picker.dart';

class CreateWorkspaceViewModel extends ChangeNotifier {

  final MessageService messageService = MessageService();
  // user data provider for token & current user
  UserDataProvider? userDataProvider;
  // new workspace data to create
  WorkspaceEntity newWorkspaceData = WorkspaceEntity.newWorkspace();
  // temp avatar file before upload to server
  XFile? tempAvatarFile;
  // tag for new workspace
  String tag = "";
  // space colors
  List<Color> spaceColors = AppColor.spaceColors;
  // space color index
  Color get spaceColor => AppColor.getWorkspaceColorByIndex(newWorkspaceData.themeColor);
  // create state

  void clearTag(){
    tag = "";
    notifyListeners();
  }
  
  void deleteTag(int index) {
    newWorkspaceData.tags.removeAt(index);
    notifyListeners();
  }

  void addTag(String value ) {
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

  String? spaceNameValidator (String? value) {
    if(value == null || value.isEmpty){
      return "小組名稱請勿留空";
    }
    return null;
  }

  String? spaceDescriptionValidator (String? value) {
    if(value == null || value.isEmpty){
      return "小組介紹請勿留空";
    }
    return null;
  }

  
  Future<bool> createWorkspace() async {

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
        debugPrint('create workspace failure: $failure'),
          messageService.addMessage(MessageData.error(
            title: "新增小組失敗",
            message: "$failure",
          ),
          autoClear: false
        ),
      },
      (workspace) => {
        newWorkspaceData = workspace,
        isSuccess = true,
        debugPrint('create workspace success: $newWorkspaceData'),
      },
    );
    
    if(!isSuccess){
      return false;
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

    return true;
  }

  void update(UserDataProvider userDataProvider) {
    this.userDataProvider = userDataProvider;
    newWorkspaceData = WorkspaceEntity.newWorkspace();
    notifyListeners();
  }
}