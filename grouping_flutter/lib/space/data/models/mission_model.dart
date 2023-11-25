// ignore_for_file: unnecessary_this
import 'package:grouping_project/core/exceptions/exception.dart';
import 'package:grouping_project/space/data/models/account_model.dart';
import 'package:grouping_project/space/data/models/editable_card_model.dart';

import 'mission_state_model.dart';
// import 'package:grouping_project/exception.dart';

// import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

/// ## a data model for misison
/// * to upload/download, use `DataController`
class MissionModel extends EditableCardModel {
  // String title;
  DateTime deadline;
  // List<String> contributorIds;
  // String introduction;
  String stateId;
  MissionStateModel state;
  // List<String> tags;
  // List<DateTime> notifications;
  List<String> parentMissionIds;
  List<String> childMissionIds;
  // AccountModel ownerAccount;

  static final MissionModel defaultMission = MissionModel._default();

  MissionModel._default()
      :
        // : this.title = 'unknown',
        this.deadline = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
        // this.contributorIds = [],
        // this.introduction = 'unknown',
        this.stateId = MissionStateModel.defaultUnknownState.id!,
        this.state = MissionStateModel.defaultUnknownState,
        // this.tags = [],
        // this.notifications = [],
        this.parentMissionIds = [],
        this.childMissionIds = [],
        // this.ownerAccount = AccountModel.defaultAccount,
        super(
          title: 'unknown',
          contributors: [],
          introduction: 'unknown',
          // tags: [],
          notifications: [],
          creatorAccount: AccountModel.defaultAccount,
          id: 0,
          // databasePath: 'mission',
          // storageRequired: false,
        );

  /// ## a data model for mission
  /// * to upload/download, use `DataController`
  /// -----
  /// - recommend to pass state using [state]
  /// - if [state] is not given, will then seek [stateModelId], [stage], [stateName]
  /// - if all above is not given, seek the attribute of [defaultMission]
  MissionModel({
    super.id,
    String? title,
    DateTime? deadline,
    List<int>? contributors,
    String? introduction,
    String? stateId,
    MissionStateModel? state,
    List<String>? tags,
    List<DateTime>? notifications,
    List<String>? parentMissionIds,
    List<String>? childMissionIds,
    // AccountModel? ownerAccount,
  })  : this.deadline = deadline ?? defaultMission.deadline,
        // this.contributorIds = contributorIds ?? defaultMission.contributorIds,
        // this.introduction = introduction ?? defaultMission.introduction,
        this.stateId = state?.id ?? (stateId ?? defaultMission.stateId),
        this.state = state ?? defaultMission.state,
        // this.tags = tags ?? defaultMission.tags,
        // this.notifications = notifications ?? defaultMission.notifications,
        this.parentMissionIds =
            parentMissionIds ?? defaultMission.parentMissionIds,
        this.childMissionIds =
            childMissionIds ?? defaultMission.childMissionIds,
        // this.ownerAccount = defaultMission.ownerAccount,
        super(
          title: title ?? defaultMission.title,
          contributors: contributors ?? List.from(defaultMission.contributors),
          introduction: introduction ?? defaultMission.introduction,
          // tags: tags ?? List.from(defaultMission.tags),
          notifications:
              notifications ?? List.from(defaultMission.notifications),
          creatorAccount: defaultMission.creatorAccount,
          // databasePath: defaultMission.databasePath,
          // storageRequired: defaultMission.storageRequired,
          // setOwnerRequired: true
        );

  /// convert `List<DateTime>` to `List<Timestamp>`
  // List<Timestamp> _toFirestoreTimeList(List<DateTime> dateTimeList) {
  //   List<Timestamp> processList = [];
  //   for (DateTime dateTime in dateTimeList) {
  //     processList.add(Timestamp.fromDate(dateTime));
  //   }
  //   return processList;
  // }

  // /// convert `List<Timestamp>` to `List<DateTime>`
  // List<DateTime> _fromFirestoreTimeList(List<Timestamp> timestampList) {
  //   List<DateTime> processList = [];
  //   for (Timestamp timestamp in timestampList) {
  //     processList.add(timestamp.toDate());
  //   }
  //   return processList;
  // }

  factory MissionModel.fromJson({required Map<String, dynamic> data}) =>
      MissionModel(
          id: data['id'] as int,
          title: data['title'] as String,
          introduction: data['description'] as String,
          deadline: DateTime.parse(data['mission']['deadline']),
          // state: MissionStateModel.fromJson(data: data['state']),
          stateId: data['mission']['state'].toString(),
          contributors: data['contributors'].cast<int>() as List<int>,
          // tags: data['tags'].cast<String>() as List<String>,
          parentMissionIds: data['parents'].cast<String>() as List<String>,
          childMissionIds: data['children'].cast<String>() as List<String>,
          notifications: _notificationFromJson(
              data['notifications'].cast<Map<String, String>>()));

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'title': this.title,
        'description': this.introduction,
        'mission': {
          "deadline": this.deadline.toIso8601String(),
          "state": this.state.id,
        },
        // 'stateId': this.stateId,
        'contributors': this.contributors,
        // 'tags': this.tags,
        'parents': this.parentMissionIds,
        'children': this.childMissionIds,
        'notifications': _notificationsToJson(),
      };

  List<Map<String, String>> _notificationsToJson() {
    List<Map<String, String>> notiMap = [];
    for (DateTime noti in this.notifications) {
      notiMap.add({"notify_time": noti.toIso8601String()});
    }
    return notiMap;
  }

  static List<DateTime> _notificationFromJson(List<Map<String, String>> data) {
    List<DateTime> noti = [];
    for (Map<String, String> object in data) {
      noti.add(DateTime.parse(object.values.elementAt(0)));
    }
    return noti;
  }

  // /// set the data about owner for this instance
  // void setOwner({required AccountModel ownerAccount}) {
  //   this.ownerAccount = ownerAccount;
  // }

  /// ### This is the perfered method to change state of mission
  /// - please make sure the [stateModel] is a correct model in database
  void setStateByStateModel(MissionStateModel stateModel) {
    if (stateModel.id != null) {
      stateId = stateModel.id!;
      state = stateModel;
    } else {
      throw GroupingProjectException(
          message: 'This state model is not from the database.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }
  }

  @override
  String toString() {
    return {
      "id": this.id,
      "title": this.title,
      "introduction": this.introduction,
      "deadline": this.deadline,
      "contributors": this.contributors,
      "notifications": this.notifications,
      "parentMissionIds": this.parentMissionIds,
      "childMissionIds": this.childMissionIds,
      // "tags": this.tags,
      'state': this.state,
      'stateId': this.stateId
    }.toString();
  }

  @override
  bool operator ==(Object other) {
    return this.toString() == other.toString();
  }
  
  @override
  // TODO: implement hashCode
  int get hashCode => id!;
}
