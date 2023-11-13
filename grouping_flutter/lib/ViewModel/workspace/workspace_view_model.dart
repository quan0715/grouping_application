import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:grouping_project/View/components/workspace_chip.dart';
import 'package:grouping_project/View/shared/components/components.dart';
import 'package:grouping_project/ViewModel/message_service.dart';
import 'package:grouping_project/model/workspace/message_model.dart';
import 'package:grouping_project/model/auth/account_model.dart';
import 'package:grouping_project/model/repo/activity_repo.dart';
// import 'package:grouping_project/model/repo/user_repo.dart';
import 'package:grouping_project/model/workspace/workspace_model.dart';
import 'package:grouping_project/model/workspace/workspace_model_lib.dart';
// import 'package:grouping_project/model/repo/workspace_repo.dart';

class WorkspaceViewModel extends ChangeNotifier {
  final WorkspaceModel _workspace; // TODO: initial
  final AccountModel _user; // TODO: initial

  late final ActivityDatabaseService _databaseService; // TODO: initial
  // late UserService _userService;

  final MessageService _messageService = MessageService();
  MessageService get messageService => _messageService;

  int _pages = 0;

  WorkspaceViewModel({required WorkspaceModel workspace, required AccountModel user})
      : _workspace = workspace,
        _user = user,
        _databaseService = ActivityDatabaseService(
            workSpaceUid: workspace.id!, token: 'token');

  // void initialState(WorkspaceModel workspace, AccountModel user){
  //   _workspace = workspace;
  //   _user = user;
  //   _databaseService = ActivityDatabaseService(workSpaceUid: _workspace.id!, token: 'token');
  // }

  List<EventModel> get events => _user.joinedWorkspaces.whereType<EventModel>().toList();
  // List<EventModel> get events {
  //   List<EventModel> tmp = [];
  //   for(var activity in _user.contributingActivities){
  //     if(activity is EventModel) tmp.add(activity);
  //   }
  //   return tmp;
  // }

  List<MissionModel> get missions => _user.joinedWorkspaces.whereType<MissionModel>().toList();
  // List<MissionModel> get missions {
  //   List<MissionModel> tmp = [];
  //   for(var activity in _user.contributingActivities){
  //     if(activity is MissionModel) tmp.add(activity);
  //   }
  //   return tmp;
  // }

  WorkspaceChip get ownWorkspace => WorkspaceChip(workspace: _workspace);

  List<WorkspaceChip> get workspaces {
    List<WorkspaceChip> tmp = [];
    for(WorkspaceModel workspace in _user.joinedWorkspaces){
      tmp.add(WorkspaceChip(workspace: workspace));
      // debugPrint('themeColor: ${workspace.themeColor.toString()}');
    }
    return tmp;
  }
  
  int get currentWorkspaceColor => _workspace.themeColor;
  int get workspaceNumber => _user.joinedWorkspaces.length;
  int get eventNumber => _user.contributingActivities.whereType<EventModel>().length;
  int get missionNumber => _user.contributingActivities.whereType<MissionModel>().length;

  void setPage(int newPage){
    _pages = newPage;
    notifyListeners();
  }

  int getPage(){
    return _pages;
  }

  Future<void> createEvent(EventModel event) async {
    await _databaseService.createEvent(event: event);
    notifyListeners();
  }
  
  @override
  void dispose() {
    _messageService.dispose();
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
    final index =  Random().nextInt(messages.length);
    _messageService.addMessage(messages[index]); 
  }
}
