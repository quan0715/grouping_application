import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/providers/message_service.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/activity_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/activity_remote_data_source.dart';
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
// import 'package:grouping_project/space/data/datasources/activity_repo.dart';
import 'package:grouping_project/space/data/repositories/activity_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/usecases/activity_usecases/create_event_usecase.dart';
import 'package:grouping_project/space/domain/usecases/activity_usecases/delete_activity_usecase.dart';
import 'package:grouping_project/space/domain/usecases/activity_usecases/get_event_usecase.dart';
import 'package:grouping_project/space/domain/usecases/activity_usecases/update_event_usecase.dart';
// import 'package:grouping_project/model/model_lib.dart';
// import 'package:grouping_project/service/service_lib.dart';
import 'package:intl/intl.dart';

enum EventState {
  create,
  edit;
}

class EventSettingViewModel extends ChangeNotifier {
  EventSettingViewModel(
      {required this.tokenModel, required this.workspaceEntity});

  EventEntity? _event;
  UserEntity? creator;
  WorkspaceEntity? workspaceEntity;
  AuthTokenModel tokenModel = AuthTokenModel(token: "", refresh: "");
  final MessageService _messageService = MessageService();
  MessageService get messageService => _messageService;

  Future<void> init(
      {required EventState state, int? eventID, UserEntity? creator}) async {
    if (state == EventState.edit) {
      await getEvent(eventID!);
    } else if (state == EventState.create) {
      initializeNewEvent(creator: creator!);
    }
  }

  Future<void> getEvent(int eventID) async {
    // debugPrint("EventSettingViewModel getEvent");
    GetEventUseCase getEventUseCase = GetEventUseCase(ActivityRepositoryImpl(
      remoteDataSource: ActivityRemoteDataSourceImpl(
          token: tokenModel.token, workSpaceUid: workspaceEntity!.id),
      localDataSource: ActivityLocalDataSourceImpl(),
    ));

    final failureOrEvent = await getEventUseCase(eventID);

    failureOrEvent.fold(
        (failure) => messageService.addMessage(
            MessageData.error(message: failure.toString())), (event) {
      _event = event;
      creator = UserEntity.fromModel(_event!.creatorAccount);
    });
  }

  Future<void> createEvent(EventEntity event) async {
    // debugPrint("EventSettingViewModel getEvent");
    CreateEventUseCase createEventUseCase =
        CreateEventUseCase(ActivityRepositoryImpl(
      remoteDataSource: ActivityRemoteDataSourceImpl(
          token: tokenModel.token, workSpaceUid: workspaceEntity!.id),
      localDataSource: ActivityLocalDataSourceImpl(),
    ));

    final failureOrEvent = await createEventUseCase(event);

    failureOrEvent.fold(
        (failure) => messageService.addMessage(
            MessageData.error(message: failure.toString())), (event) {
      _event = event;
      creator = UserEntity.fromModel(_event!.creatorAccount);
    });
  }

  Future<void> updateEvent(EventEntity event) async {
    // debugPrint("EventSettingViewModel getEvent");
    UpdateEventUseCase updateEventUseCase =
        UpdateEventUseCase(ActivityRepositoryImpl(
      remoteDataSource: ActivityRemoteDataSourceImpl(
          token: tokenModel.token, workSpaceUid: workspaceEntity!.id),
      localDataSource: ActivityLocalDataSourceImpl(),
    ));

    final failureOrEvent = await updateEventUseCase(event);

    failureOrEvent.fold(
        (failure) => messageService.addMessage(
            MessageData.error(message: failure.toString())), (event) {
      _event = event;
      creator = UserEntity.fromModel(_event!.creatorAccount);
    });
  }

  Future<void> deleteEvent(int eventID) async {
    // debugPrint("EventSettingViewModel getEvent");
    DeleteActivityUseCase deleteActivityUseCase =
        DeleteActivityUseCase(ActivityRepositoryImpl(
      remoteDataSource: ActivityRemoteDataSourceImpl(
          token: tokenModel.token, workSpaceUid: workspaceEntity!.id),
      localDataSource: ActivityLocalDataSourceImpl(),
    ));

    final failureOrEmpty = await deleteActivityUseCase(eventID);

    failureOrEmpty.fold(
        (failure) => messageService
            .addMessage(MessageData.error(message: failure.toString())),
        (empty) => empty);
  }

  // SettingMode settingMode = SettingMode.create;
  // timer output format
  DateFormat dataFormat = DateFormat('h:mm a, MMM d, y');
  String get formattedStartTime => dataFormat.format(startTime);
  String get formattedEndTime => dataFormat.format(endTime);

  // getter of eventModel
  String get title => _event!.title; // Event title
  String get introduction => _event!.introduction; // Introduction od event
  String get ownerAccountName => creator!.name; // event owner account name
  DateTime get startTime => _event!.startTime; // event start time
  DateTime get endTime => _event!.endTime; // event end time

  // get event card Material design  color scheem seed;
  bool onTime() {
    final currentTime = DateTime.now();
    return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
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
    _event!.title = newTitle == '' ? '事件標題' : newTitle;
    notifyListeners();
  }

  String? titleValidator(value) {
    return title.isEmpty ? '不可為空' : null;
  }

  void updateIntroduction(String newIntro) {
    _event!.introduction = newIntro == '' ? '事件介紹' : newIntro;
    notifyListeners();
  }

  String? introductionValidator(value) {
    return introduction.isEmpty ? '不可為空' : null;
  }

  void updateStartTime(DateTime newStart) {
    _event!.startTime = newStart;
    if (_event!.startTime.isAfter(_event!.endTime)) {
      DateTime temp = _event!.startTime;
      _event!.startTime = _event!.endTime;
      _event!.endTime = temp;
    }
    notifyListeners();
  }

  void updateEndTime(DateTime newEnd) {
    _event!.endTime = newEnd;
    if (_event!.startTime.isAfter(_event!.endTime)) {
      DateTime temp = _event!.startTime;
      _event!.startTime = _event!.endTime;
      _event!.endTime = temp;
    }
    notifyListeners();
  }

  void initializeNewEvent({required UserEntity creator}) {
    this.creator = creator;
    // debugPrint('owner ${this.ownerAccount.id}');
    // debugPrint('ownerAccount ${ownerAccount.associateEntityAccount.length}');

    _event = EventEntity(
        id: -1,
        title: '事件標題',
        introduction: '事件介紹',
        contributors: [],
        notifications: [],
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        relatedMissionIds: [],
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
