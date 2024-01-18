import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/core/data/models/nest_workspace.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/space/data/models/mission_model.dart';
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
        'title': title,
        'description': introduction,
        'creator': creator.id,
        'belong_workspace': belongWorkspace.id,
        'event': {
          'start_time': startTime.toIso8601String(),
          'end_time': endTime.toIso8601String(),
        },
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
        creator: creator,
        createTime: createTime,
        belongWorkspace: belongWorkspace,
        childMissions: childMissions.map((mission) => mission.toEntity()).toList(),
        contributors: contributors,
        notifications: notifications,);
  }

  /// ### 用於 [EventModel] 的 [notifications]
  /// 從 List\<DateTime\> 轉換成特定 Json 格式
  List<Map<String, String>> _notificationsToJson() {
    List<Map<String, String>> notiMap = [];
    for (DateTime noti in notifications) {
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
      "id": id,
      "title": title,
      "introduction": introduction,
      "creator": creator,
      "create Time": createTime,
      "belong workspace": belongWorkspace,
      "startTime": startTime,
      "endTime": endTime,
      "child Missions": childMissions,
      "contributors": contributors,
      "notifications": notifications,
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
