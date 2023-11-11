import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grouping_project/ViewModel/message_service.dart';
import 'package:grouping_project/model/auth/account_model.dart';
import 'package:grouping_project/model/repo/activity_repo.dart';
import 'package:grouping_project/model/repo/user_repo.dart';
import 'package:grouping_project/model/workspace/message_model.dart';
import 'package:grouping_project/model/workspace/workspace_model.dart';
import 'package:grouping_project/model/workspace/workspace_model_lib.dart';
// import 'package:grouping_project/model/repo/workspace_repo.dart';

class WorkspaceViewModel extends ChangeNotifier {
  WorkspaceModel _workspace = WorkspaceModel(); // TODO: initial
  AccountModel _user = AccountModel(); // TODO: initial
  final MessageService _messageService = MessageService();
  MessageService get messageService => _messageService;

  late ActivityDatabaseService _databaseService; // TODO: initial
  late UserService _userService;

  WorkspaceViewModel(this._workspace, this._user)
      : _databaseService = ActivityDatabaseService(
            workSpaceUid: _workspace.id!, token: 'token');

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

  // void initialState(WorkspaceModel workspace, AccountModel user){
  //   _workspace = workspace;
  //   _user = user;
  //   _databaseService = ActivityDatabaseService(workSpaceUid: _workspace.id!, token: 'token');
  // }

  List<EventModel> get events {
    List<EventModel> tmp = [];
    for(var activity in _user.contributingActivities){
      if(activity is EventModel) tmp.add(activity);
    }
    return tmp;
  }

  List<MissionModel> get missions {
    List<MissionModel> tmp = [];
    for(var activity in _user.contributingActivities){
      if(activity is MissionModel) tmp.add(activity);
    }
    return tmp;
  }
}
