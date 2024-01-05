// import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
// import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';

/// ## 用於 database 儲存 mission 的資料結構
/// ### 僅可被 repository 使用
class MissionModel extends ActivityModel<MissionEntity> {
  DateTime deadline;
  // int stateID;
  MissionState state;

  /// ### default data of MissionModel (a.k.a. initial MissionModel)
  /// 
  /// 預設 [id] 為 -1, \
  /// [title]、[introduction] 為 "unknown", \
  /// [deadline] 為現在時間的一小時後, \
  /// [stateID]、[creator]、[belongWorkspaceID] 為 -1, \
  /// [childMissionIDs]、[parentMissionIDs]、[contributors]、[notifications] 為 List\<int\>(空矩陣)
  static final MissionModel defaultMission = MissionModel._default();

  MissionModel._default()
      // : this.deadline = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
      : deadline = DateTime.now().add(const Duration(hours: 1)),
        // this.stateID = MissionStateModel.defaultUnknownState.id,
        state = MissionState.defaultUnknownState,
        super(
          id: -1,
          title: 'unknown',
          introduction: 'unknown',
          creator: UserModel.defaultUser,
          createTime: DateTime.now(),
          belongWorkspace: WorkspaceModel.defaultWorkspace,
          // parentMissionIDs: [],
          childMissions: [],
          contributors: [],
          notifications: [],
        );

  /// ### [MissionModel] 的建構式，回傳非 null 的 [MissionModel]
  /// 
  /// 除了 [id] 必定要給予之外，可自由給予 [MissionModel] 的 [title]、[introduction]、\
  /// [deadline]、[state]、[creator]、[belongWorkspace]、
  /// [parentMissionIDs]、[childMissions]、[contributors]、[notifications]\
  /// 若除 [id] 外有未給予的欄位，將自動套用 [MissionModel.defaultMission] 的欄位
  MissionModel({
    required int id,
    String? title,
    String? introduction,
    DateTime? deadline,
    UserModel? creator,
    DateTime? createTime,
    WorkspaceModel? belongWorkspace,
    MissionState? state,
    // List<int>? parentMissionIDs,
    List<MissionModel>? childMissions,
    List<UserModel>? contributors,
    List<DateTime>? notifications,
    // MissionStateModel? state,
  })  : deadline = deadline ?? defaultMission.deadline,
        state = state ?? defaultMission.state,
        // this.stateId = state?.id ?? (stateId ?? defaultMission.stateId),
        // this.state = state ?? defaultMission.state,
        super(
          id: id,
          title: title ?? defaultMission.title,
          introduction: introduction ?? defaultMission.introduction,
          creator: creator ?? defaultMission.creator,
          createTime: createTime ?? defaultMission.createTime,
          belongWorkspace: belongWorkspace ?? defaultMission.belongWorkspace,
          // parentMissionIDs: parentMissionIDs ?? defaultMission.parentMissionIDs,
          childMissions: childMissions ?? defaultMission.childMissions,
          contributors: contributors ?? List.from(defaultMission.contributors),
          notifications:
              notifications ?? List.from(defaultMission.notifications),
        );

  /// ### 藉由特定的 Json 格式來建構的 [MissionModel]
  factory MissionModel.fromJson({required Map<String, dynamic> data}) =>
      MissionModel(
          id: data['id'] as int,
          title: (data['title'] ?? defaultMission.title) as String,
          introduction: (data['description'] ?? defaultMission.introduction) as String,
          deadline: data['mission']['deadline'] != null ? DateTime.parse(data['mission']['deadline']) : DateTime.now().add(const Duration(hours: 1)),
          state: data['mission']['state'] != null ? MissionState.fromJson(data: data['mission']['state']) : MissionState.defaultUnknownState,
          creator: data['creator'] != null ? UserModel.fromJson(data: data['creator']) : UserModel.defaultUser,
          createTime: data['created_at'] != null ? DateTime.parse(data['created_at']) : DateTime.now(),
          belongWorkspace: data['belong_workspace'] != null ? WorkspaceModel.fromJson(data: data['belong_workspace']) : defaultMission.belongWorkspace,
          // parentMissionIDs: (data['parents'] ?? []).cast<int>() as List<int>,
          childMissions: (data['children'] ?? []).cast<MissionModel>() as List<MissionModel>,
          contributors: (data['contributors'] ?? []).cast<UserModel>() as List<UserModel>,
          notifications: _notificationFromJson(
              (data['notifications'] ?? []).cast<Map<String, String>>() as List<Map<String, String>>),
          );

  /// ### 將 [MissionModel] 轉換成特定的 Json 格式
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        // 'id': this.id,
        'title': title,
        'description': introduction,
        'creator': creator.id,
        // 'created_at': createTime.toIso8601String(),
        'belong_workspace': belongWorkspace.id,
        'mission': {
          "deadline": deadline.toIso8601String(),
          "state": state.id,
        },
        // 'children': childMissions.map((mission) => mission.toJson()).toList(),
        // 'contributors': contributors.map((contributor) => contributor.toJson()).toList(),
        'notifications': _notificationsToJson(),
      };

  @override
  MissionEntity toEntity(){
    return MissionEntity(
        id: id!,
        title: title,
        introduction: introduction,
        // creator: UserEntity.fromModel(creator),
        creator: creator.toEntity(),
        createTime: createTime,
        // belongWorkspace: WorkspaceEntity.fromModel(belongWorkspace),
        belongWorkspace: belongWorkspace.toEntity(),
        deadline: deadline,
        state: state,
        // parentMissionIDs: parentMissionIDs,
        // childMissions: childMissions.map((mission) => MissionEntity.fromModel(mission)).toList(),
        childMissions: childMissions.map((mission) => mission.toEntity()).toList(),
        // contributors: contributors.map((contributor) => UserEntity.fromModel(contributor)).toList(),
        contributors: contributors.map((contributor) => contributor.toEntity()).toList(),
        notifications: notifications,);
  }

  // factory MissionModel.fromEntity(MissionEntity entity){
  //   return MissionModel(
  //     id: entity.id,
  //     title: entity.title,
  //     introduction: entity.introduction,
  //     deadline: entity.deadline,
  //     state: entity.state,
  //     creator: UserModel.fromEntity(entity.creator),
  //     createTime: entity.createTime,
  //     belongWorkspace: WorkspaceModel.fromEntity(entity.belongWorkspace),
  //     contributors: entity.contributors.map((contributor) => UserModel.fromEntity(contributor)).toList(),   // TODO: id must exist in entity
  //     // parentMissionIDs: entity.parentMissions.map((mission) => MissionModel.fromEntity(mission)).toList(),
  //     childMissions: entity.childMissions.map((mission) => MissionModel.fromEntity(mission)).toList(),
  //     notifications: entity.notifications,
  //   );
  // }

  /// ### 用於 [MissionModel] 的 [notifications]
  /// 從 List\<DateTime\> 轉換成特定 Json 格式
  List<Map<String, String>> _notificationsToJson() {
    List<Map<String, String>> notiMap = [];
    for (DateTime noti in notifications) {
      notiMap.add({"notify_time": noti.toIso8601String()});
    }
    return notiMap;
  }

  /// ### 用於 [MissionModel] 的 [notifications]
  /// 從特定 Json 格式轉換成 List\<DateTime\>
  static List<DateTime> _notificationFromJson(List<Map<String, String>> data) {
    List<DateTime> noti = [];
    for (Map<String, String> object in data) {
      noti.add(DateTime.parse(object.values.elementAt(0)));
    }
    return noti;
  }

  @override
  String toString() {
    return {
      "id": id,
      "title": title,
      "introduction": introduction,
      "deadline": deadline,
      "state": state,
      "creator": creator,
      "create Time": createTime,
      "workspace": belongWorkspace,
      "contributors": contributors,
      "notifications": notifications,
      // "parent Missions": parentMissionIDs,
      "child Missions": childMissions,
      // "tags": this.tags,
    }.toString();
  }

  @override
  bool operator ==(Object other) {
    return toString() == other.toString();
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id!;
}
