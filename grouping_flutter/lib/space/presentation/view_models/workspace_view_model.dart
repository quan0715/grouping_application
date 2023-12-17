import 'package:flutter/material.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
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

// class WorkspaceViewModel extends ChangeNotifier {

//   int _pages = 0;

//   int get currentPageIndex => _pages;

//   // final MessageService _messageService = MessageService();
//   // MessageService get messageService => _messageService;
//   UserDataProvider? userDataProvider;
//   GroupDataProvider? workspaceDataProvider;

//   void updateCurrentIndex(int index){
//     _pages = index;
//     notifyListeners();
//   }

//   Future<void> init() async {
//     // TODO: how do i know the workspaceID of this id?
//     // await getCurrentWorkspace(0);
//   }

  // TODO: this use case in user viewmodel? since workspace shouldn't create workspace
  // Future createWorkspace(WorkspaceEntity entity) async {
  //   debugPrint("WorkspaceViewModel createWorkspace");
  //   CreateCurrentWorkspaceUseCase createCurrentWorkspaceUseCase =
  //       CreateCurrentWorkspaceUseCase(WorkspaceRepositoryImpl(
  //     remoteDataSource:
  //         WorkspaceRemoteDataSourceImpl(token: await getAccessToken()),
  //     localDataSource: WorkspaceLocalDataSourceImpl(),
  //   ));

  //   final failureOrWorkspace = await createCurrentWorkspaceUseCase(entity);

  //   failureOrWorkspace.fold((failure) {
  //     messageService.addMessage(MessageData.error(message: failure.toString()));
  //   }, (workspace) {
  //     debugPrint("WorkspaceViewmodel createWorkspace success");
  //     return workspace;
  //   });
  // }

  // Future deleteCurrentWorkspace(int workspaceID) async {
  //   debugPrint("WorkspaceViewModel getCurrentWorkspace");
  //   DeleteCurrentWorkspaceUseCase deleteCurrentWorkspaceUseCase =
  //       DeleteCurrentWorkspaceUseCase(WorkspaceRepositoryImpl(
  //     remoteDataSource:
  //         WorkspaceRemoteDataSourceImpl(token: tokenModel.token),
  //     localDataSource: WorkspaceLocalDataSourceImpl(),
  //   ));

  //   final failureOrWorkspace = await deleteCurrentWorkspaceUseCase(workspaceID);

  //   failureOrWorkspace.fold(
  //       (failure) => messageService.addMessage(
  //           MessageData.error(message: failure.toString())), (empty) {
  //     debugPrint("WorkspaceViewModel DeleteCurrentWorkspace success");
  //   });
  // }

  // List<EventModel> get events => _user.joinedWorkspaces.whereType<EventModel>().toList();
  // List<EventModel> getEvents() =>
  //     _workspace!.activities.whereType<EventModel>().toList();
  // // int get eventNumber => _user.contributingActivities.whereType<EventModel>().length;
  // int getEventLength() => _workspace!.activities
  //     .whereType<EventModel>()
  //     .toList()
  //     .length;

  // // List<MissionModel> get missions => _user.joinedWorkspaces.whereType<MissionModel>().toList();
  // List<MissionModel> getMissions() =>
  //     _workspace!.activities.whereType<MissionModel>().toList();
  // // int get missionNumber => _user.contributingActivities.whereType<MissionModel>().length;
  // int getMissionLength() => _workspace!.activities
  //     .whereType<MissionModel>()
  //     .toList()
  //     .length;

  // WorkspaceEntity getEntity() => _workspace!;
  

  // WorkspaceChip get ownWorkspace => WorkspaceChip(workspace: _workspace);

  // int get workspaceNumber => _user.joinedWorkspaces.length;



  // Future<void> createEvent(EventModel event) async {
  //   await _databaseService.createEvent(event: event);
  //   notifyListeners();
  // }

//   @override
//   void dispose() {
//     // _messageService.dispose();
//     super.dispose();
//   }

//   void onPress() {
//     // for testing purpose
//     // it will be remove in next version
//     final messages = [
//       MessageData.success(),
//       MessageData.error(),
//       MessageData.warning(),
//     ];
//     Random().nextInt(messages.length);
//     // _messageService.addMessage(messages[index]);
//   }

//   update(UserDataProvider userDataProvider) {
//     this.userDataProvider = userDataProvider;
//     notifyListeners();
//   }
// }
