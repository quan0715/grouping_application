// ignore_for_file: unnecessary_this
// import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/core/data/models/nest_workspace.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/space/data/models/mission_model.dart';
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
// import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';

/// ## 用於 database 儲存 event 的資料結構
/// ### 僅可被 repository 使用
class EventModel extends ActivityModel {
  DateTime startTime;
  DateTime endTime;


  /// ### EventModel 的建構式，回傳非 null 的 [EventModel]
  /// 
  /// 除了 [id] 必定要給予之外，可自由給予 [EventModel] 的 [title]、[introduction]、\
  /// [startTime]、[endTime]、[creator]、[belongWorkspace]、[childMissions]、\
  /// [contributors]、[notifications]\
  /// 若除 [id] 外有未給予的欄位，將自動套用 [EventModel.defaultEvent] 的欄位
  EventModel(
      {required super.id,
      required super.title,
      required super.introduction,
      required super.creator,
      required super.createTime,
      required super.belongWorkspace,
      required super.childMissions,
      required super.contributors,
      required super.notifications,
      required this.startTime,
      required this.endTime,});

  /// ### 藉由特定的 Json 格式來建構的 [EventModel]
  factory EventModel.fromJson({required Map<String, dynamic> data}) =>
      EventModel(
          id: data['id'] as int,
          title: data['title'] as String,
          introduction: data['description'] as String,
          creator: Member.fromJson(data: data['creator']),
          createTime: DateTime.parse(data['created_at']),
          startTime: DateTime.parse(data['event']['start_time']),
          endTime: DateTime.parse(data['event']['end_time']),
          belongWorkspace: NestWorkspace.fromJson(data: data['belong_workspace']),
          childMissions: data['children'].cast<MissionModel>() as List<MissionModel>,
          contributors: (data['contributors'].cast<Map<String, dynamic>>() as List<Map<String, dynamic>>).map((contributor) => Member.fromJson(data: contributor)).toList(),
          notifications: _notificationFromJson(data['notifications'].cast<Map<String, String>>() as List<Map<String, String>>),);

  /// ### 將 [EventModel] 轉換成特定的 Json 格式
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        // 'id': this.id,
        'title': this.title,
        'description': this.introduction,
        'creator': this.creator.id,
        // 'created_at': this.createTime.toIso8601String(),
        'belong_workspace': belongWorkspace.id,
        'event': {
          'start_time': this.startTime.toIso8601String(),
          'end_time': this.endTime.toIso8601String(),
        },
        // 'children': childMissions.map((mission) => mission.toJson()).toList(),
        // 'contributors': this.contributors.map((contributor) => contributor.toJson()).toList(),
        'notifications': _notificationsToJson(),
      };

  @override
  EventEntity toEntity() {
    return EventEntity(
        id: id,
        title: title,
        introduction: introduction,
        startTime: startTime,
        endTime: endTime,
        // creator: UserEntity.fromModel(creator),
        creator: creator,
        createTime: createTime,
        // belongWorkspace: WorkspaceEntity.fromModel(belongWorkspace),
        belongWorkspace: belongWorkspace,
        // childMissions: childMissions.map((mission) => MissionEntity.fromModel(mission)).toList(),
        childMissions: childMissions.map((mission) => mission.toEntity()).toList(),
        // contributors: contributors.map((contributor) => UserEntity.fromModel(contributor)).toList(),
        // contributors: contributors.map((contributor) => contributor.toEntity()).toList(),
        contributors: contributors,
        notifications: notifications,);
  }

  // factory EventModel.fromEntity(EventEntity entity){
  //   return EventModel(
  //     id: entity.id,
  //     title: entity.title,
  //     introduction: entity.introduction,
  //     creator: UserModel.fromEntity(entity.creator),
  //     createTime: entity.createTime,
  //     belongWorkspace: WorkspaceModel.fromEntity(entity.belongWorkspace),
  //     startTime: entity.startTime,
  //     endTime: entity.endTime,
  //     childMissions: entity.childMissions.map((mission) => MissionModel.fromEntity(mission)).toList(),
  //     contributors: entity.contributors.map((contributor) => UserModel.fromEntity(contributor)).toList(),
  //     notifications: entity.notifications,
  //   );
  // }

  /// ### 用於 [EventModel] 的 [notifications]
  /// 從 List\<DateTime\> 轉換成特定 Json 格式
  List<Map<String, String>> _notificationsToJson() {
    List<Map<String, String>> notiMap = [];
    for (DateTime noti in this.notifications) {
      notiMap.add({"notify_time": noti.toIso8601String()});
    }
    return notiMap;
  }

  /// ### 用於 [EventModel] 的 [notifications]
  /// 從特定 Json 格式轉換成 List\<DateTime\>
  static List<DateTime> _notificationFromJson(List<Map<String, String>> data) {
    List<DateTime> noti = [];
    for (Map<String, String> object in data) {
      noti.add(DateTime.parse(object["notify_time"] as String));
    }
    return noti;
  }

  @override
  String toString() {
    return {
      "id": this.id,
      "title": this.title,
      "introduction": this.introduction,
      "creator": this.creator,
      "create Time": this.createTime,
      "belong workspace": this.belongWorkspace,
      "startTime": this.startTime,
      "endTime": this.endTime,
      "child Missions": this.childMissions,
      "contributors": this.contributors,
      "notifications": this.notifications,
    }.toString();
  }

  @override
  bool operator ==(Object other) {
    return this.toString() == other.toString();
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id;
}
