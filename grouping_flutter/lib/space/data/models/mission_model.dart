// import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/core/data/models/nest_workspace.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
// import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';

/// ## 用於 database 儲存 mission 的資料結構
/// ### 僅可被 repository 使用
class MissionModel extends ActivityModel {
  DateTime deadline;
  // int stateID;
  MissionState state;

  /// ### [MissionModel] 的建構式，回傳非 null 的 [MissionModel]
  /// 
  /// 除了 [id] 必定要給予之外，可自由給予 [MissionModel] 的 [title]、[introduction]、\
  /// [deadline]、[state]、[creator]、[belongWorkspace]、
  /// [parentMissionIDs]、[childMissions]、[contributors]、[notifications]\
  /// 若除 [id] 外有未給予的欄位，將自動套用 [MissionModel.defaultMission] 的欄位
  MissionModel({
    required super.id,
    required super.title,
    required super.introduction,
    required super.creator,
    required super.createTime,
    required super.belongWorkspace,
    required super.childMissions,
    required super.contributors,
    required super.notifications,
    required this.state,
    required this.deadline,
    // MissionStateModel? state,
  });

  /// ### 藉由特定的 Json 格式來建構的 [MissionModel]
  factory MissionModel.fromJson({required Map<String, dynamic> data}) =>
      MissionModel(
          id: data['id'] as int,
          title: data['title'] as String,
          introduction: data['description'] as String,
          deadline: DateTime.parse(data['mission']['deadline']),
          state: MissionState.fromJson(data: data['mission']['state']),
          creator: UserModel.fromJson(data: data['creator']),
          createTime: DateTime.parse(data['created_at']),
          belongWorkspace: NestWorkspace.fromJson(data: data['belong_workspace']),
          // parentMissionIDs: (data['parents'] ?? []).cast<int>() as List<int>,
          childMissions: data['children'].cast<MissionModel>() as List<MissionModel>,
          contributors: data['contributors'].cast<UserModel>() as List<UserModel>,
          notifications: _notificationFromJson(data['notifications'].cast<Map<String, String>>() as List<Map<String, String>>),
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
        id: id,
        title: title,
        introduction: introduction,
        // creator: UserEntity.fromModel(creator),
        creator: creator.toEntity(),
        createTime: createTime,
        // belongWorkspace: WorkspaceEntity.fromModel(belongWorkspace),
        belongWorkspace: belongWorkspace,
        deadline: deadline,
        state: state,
        // parentMissionIDs: parentMissionIDs,
        // childMissions: childMissions.map((mission) => MissionEntity.fromModel(mission)).toList(),
        childMissions: childMissions.map((mission) => mission.toEntity()).toList(),
        // contributors: contributors.map((contributor) => UserEntity.fromModel(contributor)).toList(),
        contributors: contributors.map((contributor) => contributor.toEntity()).toList(),
        notifications: notifications,);
  }

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
  int get hashCode => id;
}
