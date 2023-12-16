import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/providers/message_service.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/workspace_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/workspace_remote_data_source.dart';
import 'package:grouping_project/space/data/models/event_model.dart';
import 'package:grouping_project/space/data/models/mission_model.dart';
import 'package:grouping_project/space/data/repositories/workspace_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/space_profile_entity.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/workspace_usecaes_lib.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';

class WorkspaceDataProvider extends ChangeNotifier {
  WorkspaceDataProvider(
    this.messageService, {required this.tokenModel});

  final AuthTokenModel tokenModel;
  WorkspaceEntity? currentWorkspace;
  final MessageService? messageService;

  Future updateWorkspace() async {
    debugPrint("WorkspaceViewModel getCurrentWorkspace");

    GetCurrentWorkspaceUseCase getCurrentWorkspaceUseCase =
        GetCurrentWorkspaceUseCase(WorkspaceRepositoryImpl(
      remoteDataSource:
          WorkspaceRemoteDataSourceImpl(token: tokenModel.token),
      localDataSource: WorkspaceLocalDataSourceImpl(),
    ));

    final failureOrWorkspace = await getCurrentWorkspaceUseCase(currentWorkspace!.id);

    failureOrWorkspace.fold(
        (failure) => messageService!.addMessage(
            MessageData.error(message: failure.toString())), (workspace) {
      currentWorkspace = workspace;
      debugPrint("WorkspaceViewModel getCurrentWorkspace success");
      // print user data
      debugPrint(workspace.toString());
    });
  }

  void update() {
    // workspaceViewModel.update(this);
  }
}

class WorkspaceViewModel extends ChangeNotifier {

  int _pages = 0;

  int get currentPageIndex => _pages;

  // final MessageService _messageService = MessageService();
  // MessageService get messageService => _messageService;
  UserDataProvider? userDataProvider;
  WorkspaceDataProvider? workspaceDataProvider;

  void updateCurrentIndex(int index){
    _pages = index;
    notifyListeners();
  }

  Future<void> init() async {
    // TODO: how do i know the workspaceID of this id?
    // await getCurrentWorkspace(0);
  }

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

  @override
  void dispose() {
    // _messageService.dispose();
    super.dispose();
  }

  void onPress() {
    // for testing purpose
    // it will be remove in next version
    final messages = [
      MessageData.success(),
      MessageData.error(),
      MessageData.warning(),
    ];
    final index = Random().nextInt(messages.length);
    // _messageService.addMessage(messages[index]);
  }

  update(UserDataProvider userDataProvider) {
    this.userDataProvider = userDataProvider;
    notifyListeners();
  }
}
