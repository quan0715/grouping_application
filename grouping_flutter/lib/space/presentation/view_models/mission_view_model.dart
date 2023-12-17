import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/providers/message_service.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/activity_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/activity_remote_data_source.dart';
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/data/models/workspace_model_lib.dart';
// import 'package:grouping_project/space/data/datasources/activity_repo.dart';
import 'package:grouping_project/space/data/repositories/activity_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/usecases/activity_usecases/create_mission_usecase.dart';
import 'package:grouping_project/space/domain/usecases/activity_usecases/delete_activity_usecase.dart';
import 'package:grouping_project/space/domain/usecases/activity_usecases/get_mission_usecase.dart';
import 'package:grouping_project/space/domain/usecases/activity_usecases/update_mission_usecase.dart';
// import 'package:grouping_project/model/model_lib.dart';
// import 'package:grouping_project/service/service_lib.dart';
import 'package:intl/intl.dart';

enum MissionState {
  create,
  edit;
}

class MissionSettingViewModel extends ChangeNotifier {
  MissionSettingViewModel(
      {required this.tokenModel, required this.workspaceEntity});

  MissionEntity? _mission;
  UserEntity? creator;
  WorkspaceEntity? workspaceEntity;
  AuthTokenModel tokenModel = AuthTokenModel(token: "", refresh: "");
  final MessageService _messageService = MessageService();
  MessageService get messageService => _messageService;

  Future<void> init(
      {required MissionState state, int? missionID, UserEntity? creator}) async {
    if (state == MissionState.edit) {
      await getMission(missionID!);
    } else if (state == MissionState.create) {
      initializeNewMission(creator: creator!);
    }
  }

  Future<void> getMission(int missionID) async {
    // debugPrint("EventSettingViewModel getEvent");
    GetMissionUseCase getMissionUseCase = GetMissionUseCase(ActivityRepositoryImpl(
      remoteDataSource: ActivityRemoteDataSourceImpl(
          token: tokenModel.token, workSpaceUid: workspaceEntity!.id),
      localDataSource: ActivityLocalDataSourceImpl(),
    ));

    final failureOrMission = await getMissionUseCase(missionID);

    failureOrMission.fold(
        (failure) => messageService.addMessage(
            MessageData.error(message: failure.toString())), (mission) {
      _mission = mission;
      creator = UserEntity.fromModel(_mission!.creatorAccount);
    });
  }

  Future<void> createMission(MissionEntity mission) async {
    // debugPrint("EventSettingViewModel getEvent");
    CreateMissionUseCase createMissionUseCase =
        CreateMissionUseCase(ActivityRepositoryImpl(
      remoteDataSource: ActivityRemoteDataSourceImpl(
          token: tokenModel.token, workSpaceUid: workspaceEntity!.id),
      localDataSource: ActivityLocalDataSourceImpl(),
    ));

    final failureOrMission = await createMissionUseCase(mission);

    failureOrMission.fold(
        (failure) => messageService.addMessage(
            MessageData.error(message: failure.toString())), (mission) {
      _mission = mission;
      creator = UserEntity.fromModel(_mission!.creatorAccount);
    });
  }

  Future<void> updateMission(MissionEntity mission) async {
    // debugPrint("EventSettingViewModel getEvent");
    UpdateMissionUseCase updateMissionUseCase =
        UpdateMissionUseCase(ActivityRepositoryImpl(
      remoteDataSource: ActivityRemoteDataSourceImpl(
          token: tokenModel.token, workSpaceUid: workspaceEntity!.id),
      localDataSource: ActivityLocalDataSourceImpl(),
    ));

    final failureOrMission = await updateMissionUseCase(mission);

    failureOrMission.fold(
        (failure) => messageService.addMessage(
            MessageData.error(message: failure.toString())), (mission) {
      _mission = mission;
      creator = UserEntity.fromModel(_mission!.creatorAccount);
    });
  }

  Future<void> deleteMission(int missionID) async {
    // debugPrint("EventSettingViewModel getEvent");
    DeleteActivityUseCase deleteActivityUseCase =
        DeleteActivityUseCase(ActivityRepositoryImpl(
      remoteDataSource: ActivityRemoteDataSourceImpl(
          token: tokenModel.token, workSpaceUid: workspaceEntity!.id),
      localDataSource: ActivityLocalDataSourceImpl(),
    ));

    final failureOrEmpty = await deleteActivityUseCase(missionID);

    failureOrEmpty.fold(
        (failure) => messageService
            .addMessage(MessageData.error(message: failure.toString())),
        (empty) => empty);
  }

  // SettingMode settingMode = SettingMode.create;
  // timer output format
  DateFormat dataFormat = DateFormat('h:mm a, MMM d, y');
  String get formattedDeadline => dataFormat.format(deadline);


  String get title => _mission!.title; // Mission title
  String get introduction => _mission!.introduction; // Introduction of mission
  String get ownerAccountName => creator!.name; // mission owner account name
  DateTime get deadline => _mission!.deadline; // mission deadline
  // get event card Material design  color scheem seed;
  bool onTime() {
    final currentTime = DateTime.now();
    return currentTime.isBefore(deadline);
  }

  // double onTimePercentage() {
  //   Duration eventTotalTime = endTime.difference(startTime);
  //   Duration currentTime = endTime.difference(DateTime.now());
  //   return 1 - (currentTime.inSeconds / eventTotalTime.inSeconds);
  // }

  // void updateContibutor(AccountModel model) {
  //   isContributors(model)
  //       ? eventModel.contributorIds.remove(model.id!)
  //       : eventModel.contributorIds.add(model.id!);
  //   notifyListeners();
  // }

  // bool isContributors(AccountModel model) =>
  //     eventModel.contributorIds.contains(model.id!);

  void updateTitle(String newTitle) {
    _mission!.title = newTitle == '' ? '事件標題' : newTitle;
    notifyListeners();
  }

  String? titleValidator(value) {
    return title.isEmpty ? '不可為空' : null;
  }

  void updateIntroduction(String newIntro) {
    _mission!.introduction = newIntro == '' ? '事件介紹' : newIntro;
    notifyListeners();
  }

  String? introductionValidator(value) {
    return introduction.isEmpty ? '不可為空' : null;
  }

  void updateDeadline(DateTime newDeadline) {
    _mission!.deadline = newDeadline;
    notifyListeners();
  }

  void initializeNewMission({required UserEntity creator}) {
    this.creator = creator;
    // debugPrint('owner ${this.ownerAccount.id}');
    // debugPrint('ownerAccount ${ownerAccount.associateEntityAccount.length}');

    _mission = MissionEntity(
        id: -1,
        title: '事件標題',
        introduction: '事件介紹',
        contributors: [],
        notifications: [],
        deadline: DateTime.now().add(const Duration(hours: 1)),
        stateId: -1,
        state: MissionStateModel.defaultProgressState,
        parentMissionIds: [],
        childMissionIds: [],
        creatorAccount: UserModel.fromEntity(creator),
        belongWorkspace: WorkspaceModel.defaultWorkspace);

    notifyListeners();
  }

  // Future<void> initializeDisplayEvent(
  //     {required EventModel model, required AccountModel user}) async {
  //   eventModel = model;
  //   creatorAccount = user;
  //   forUser = eventOwnerAccount.id! == creatorAccount.id!;
  //   isLoading = true;
  //   notifyListeners();
  //   eventModel.ownerAccount = await DatabaseService(
  //           ownerUid: eventModel.ownerAccount.id!, forUser: false)
  //       .getAccount();
  //   isLoading = false;
  //   notifyListeners();
  // }

  // Future<bool> onSave() async {
  //   debugPrint("setting mode $settingMode");
  //   if (title.isEmpty ||
  //       introduction.isEmpty ||
  //       startTime.isAfter(endTime) ||
  //       endTime.isBefore(DateTime.now())) {
  //     return false;
  //   }
  //   if (settingMode == SettingMode.create) {
  //     await createEvent();
  //   } else if (settingMode == SettingMode.edit) {
  //     await editEvent();
  //   }
  //   return true;
  // }

  // String errorMessage() {
  //   if (title.isEmpty) {
  //     return 'Title 不能為空';
  //   } else if (introduction.isEmpty) {
  //     return 'Introduction 不能為空';
  //   } else if (startTime.isAfter(endTime)) {
  //     return '開始時間在結束時間之後';
  //   } else if (endTime.isBefore(DateTime.now())) {
  //     return '結束時間不可在現在時間之前';
  //   } else {
  //     return 'unknown error';
  //   }
  // }

  // String getTimerCounter() {
  //   // DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  //   // String formatted = formatter.format(DateTime.now());
  //   String output = "";
  //   Duration duration;
  //   // final endDate = DateTime(2023, 4, 18, 9, 30, 0);
  //   final currentTime = DateTime.now();
  //   if (currentTime.isBefore(startTime)) {
  //     output = '即將到來-還有';
  //     duration = startTime.difference(currentTime);
  //   } else if (currentTime.isAfter(startTime) &&
  //       currentTime.isBefore(endTime)) {
  //     output = '距離結束-尚餘';
  //     duration = endTime.difference(currentTime);
  //   } else {
  //     return '活動已結束';
  //   }
  //   final days = duration.inDays.toString();
  //   final hours = (duration.inHours % 24).toString();
  //   final minutes = (duration.inMinutes % 60).toString();
  //   final seconds = (duration.inSeconds % 60).toString();
  //   return '$output ${days.padLeft(2, '0')} D ${hours.padLeft(2, '0')} H ${minutes.padLeft(2, '0')} M ${seconds.padLeft(2, '0')} S';
  // }

  // String getPercentage() {
  //   // DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  //   // String formatted = formatter.format(DateTime.now());
  //   String output = "";
  //   Duration duration;
  //   // final endDate = DateTime(2023, 4, 18, 9, 30, 0);
  //   final currentTime = DateTime.now();
  //   if (currentTime.isBefore(startTime)) {
  //     output = '即將到來-還有';
  //     duration = startTime.difference(currentTime);
  //   } else if (currentTime.isAfter(startTime) &&
  //       currentTime.isBefore(endTime)) {
  //     output = '距離結束-尚餘';
  //     duration = endTime.difference(currentTime);
  //   } else {
  //     return '活動已結束';
  //   }
  //   final days = duration.inDays.toString();
  //   final hours = (duration.inHours % 24).toString();
  //   final minutes = (duration.inMinutes % 60).toString();
  //   final seconds = (duration.inSeconds % 60).toString();
  //   return '$output ${days.padLeft(2, '0')} D ${hours.padLeft(2, '0')} H ${minutes.padLeft(2, '0')} M ${seconds.padLeft(2, '0')} S';
  // }

  // Stream<DateTime> currentTimeStream = Stream<DateTime>.periodic(
  //   const Duration(seconds: 1),
  //   (_) => DateTime.now(),
  // );

}
