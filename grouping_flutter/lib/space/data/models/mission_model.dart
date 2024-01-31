import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/core/data/models/simple_workspace.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';

/// ## 用於 database 儲存 mission 的資料結構
/// ### 僅可被 repository 使用
class MissionModel extends ActivityModel {
  DateTime deadline;
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
  });

  /// ### 藉由特定的 Json 格式來建構的 [MissionModel]
  factory MissionModel.fromJson({required Map<String, dynamic> data}) =>
      MissionModel(
          id: data['id'] as int,
          title: data['title'] as String,
          introduction: data['description'] as String,
          deadline: DateTime.parse(data['mission']['deadline']),
          state: MissionState.fromJson(data: data['mission']['state']),
          creator: Member.fromJson(data: data['creator']),
          createTime: DateTime.parse(data['created_at']),
          belongWorkspace: SimpleWorkspace.fromJson(data: data['belong_workspace']),
          // parentMissionIDs: (data['parents'] ?? []).cast<int>() as List<int>,
          childMissions: data['children'].cast<MissionModel>() as List<MissionModel>,
          contributors: (data['contributors'].cast<Map<String, dynamic>>() as List<Map<String, dynamic>>).map((contributor) => Member.fromJson(data: contributor)).toList(),
          notifications: _notificationFromJson(data['notifications'].cast<Map<String, String>>() as List<Map<String, String>>),
          );

  /// ### 將 [MissionModel] 轉換成特定的 Json 格式
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'description': introduction,
        'creator': creator.id,
        'belong_workspace': belongWorkspace.id,
        'mission': {
          "deadline": deadline.toIso8601String(),
          "state": state.id,
        },
        'notifications': _notificationsToJson(),
      };

  @override
  MissionEntity toEntity(){
    return MissionEntity(
        id: id,
        title: title,
        introduction: introduction,
        creator: creator,
        createTime: createTime,
        belongWorkspace: belongWorkspace,
        deadline: deadline,
        state: state,
        // parentMissionIDs: parentMissionIDs,
        childMissions: childMissions.map((mission) => mission.toEntity()).toList(),
        contributors: contributors,
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
