// ignore_for_file: unnecessary_this
// import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/space/data/models/mission_model.dart';
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
// import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';

/// ## 用於 database 儲存 event 的資料結構
/// ### 僅可被 repository 使用
class EventModel extends ActivityModel<EventEntity> {
  DateTime startTime;
  DateTime endTime;

  /// ### default data of EventModel (a.k.a. initial EventModel)
  /// 
  /// 預設 [id] 為 -1, \
  /// [title]、[introduction] 為 "unknown", \
  /// [startTime]、[endTime] 分別為現在時間以及現在時間的一小時後, \
  /// [creator]、[belongWorkspaceID] 為 -1, \
  /// [childMissionIDs]、[contributors]、[notifications] 為 List\<int\>(空矩陣)
  static final EventModel defaultEvent = EventModel._default();

  EventModel._default()
      // : this.startTime = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
        // this.endTime = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
      : this.startTime = DateTime.now(),
        this.endTime = DateTime.now().add(const Duration(hours: 1)),
        super(
          id: -1,
          title: 'unknown',
          introduction: 'unknown',
          creator: UserModel.defaultUser,
          createTime: DateTime.now(),
          belongWorkspace: WorkspaceModel.defaultWorkspace,
          childMissions: [],
          contributors: [],
          notifications: [],
          // parentMissionIDs: [],
        );

  /// ### EventModel 的建構式，回傳非 null 的 [EventModel]
  /// 
  /// 除了 [id] 必定要給予之外，可自由給予 [EventModel] 的 [title]、[introduction]、\
  /// [startTime]、[endTime]、[creator]、[belongWorkspace]、[childMissions]、\
  /// [contributors]、[notifications]\
  /// 若除 [id] 外有未給予的欄位，將自動套用 [EventModel.defaultEvent] 的欄位
  EventModel(
      {required int id,
      String? title,
      String? introduction,
      DateTime? startTime,
      DateTime? endTime,
      UserModel? creator,
      DateTime? createTime,
      WorkspaceModel? belongWorkspace,
      List<MissionModel>? childMissions,
      List<UserModel>? contributors,
      List<DateTime>? notifications,})
      : this.startTime = startTime ?? defaultEvent.startTime,
        this.endTime = endTime ?? defaultEvent.endTime,
        super(
          id: id,
          title: title ?? defaultEvent.title,
          introduction: introduction ?? defaultEvent.introduction,
          creator: creator ?? defaultEvent.creator,
          createTime: createTime ?? defaultEvent.createTime,
          belongWorkspace: belongWorkspace ?? defaultEvent.belongWorkspace,
          childMissions: childMissions ?? defaultEvent.childMissions,
          contributors: contributors ?? List.from(defaultEvent.contributors),
          notifications: notifications ?? List.from(defaultEvent.notifications),
          // parentMissionIDs: defaultEvent.parentMissionIDs,
        );

  /// ### 藉由特定的 Json 格式來建構的 [EventModel]
  factory EventModel.fromJson({required Map<String, dynamic> data}) =>
      EventModel(
          id: data['id'] as int,
          title: (data['title'] ?? defaultEvent.title) as String,
          introduction: (data['description'] ?? defaultEvent.introduction) as String,
          creator: data['creator'] != null ? UserModel.fromJson(data: data['creator']) : UserModel.defaultUser,
          createTime: data['created_at'] != null ? DateTime.parse(data['created_at']) : DateTime.now(),
          startTime: data['event']['start_time'] != null ? DateTime.parse(data['event']['start_time']) : DateTime.now(),
          endTime: data['event']['end_time'] != null ? DateTime.parse(data['event']['end_time']) : DateTime.now().add(const Duration(hours: 1)),
          belongWorkspace: data['belong_workspace'] != null ? WorkspaceModel.fromJson(data: data['belong_workspace']) : defaultEvent.belongWorkspace,
          childMissions: (data['children'] ?? []).cast<MissionModel>() as List<MissionModel>,
          contributors: (data['contributors'] ?? []).cast<UserModel>() as List<UserModel>,
          notifications: _notificationFromJson(
              (data['notifications'] ?? []).cast<Map<String, String>>() as List<Map<String, String>>),);

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
        id: id!,
        title: title,
        introduction: introduction,
        startTime: startTime,
        endTime: endTime,
        // creator: UserEntity.fromModel(creator),
        creator: creator.toEntity(),
        createTime: createTime,
        // belongWorkspace: WorkspaceEntity.fromModel(belongWorkspace),
        belongWorkspace: belongWorkspace.toEntity(),
        // childMissions: childMissions.map((mission) => MissionEntity.fromModel(mission)).toList(),
        childMissions: childMissions.map((mission) => mission.toEntity()).toList(),
        // contributors: contributors.map((contributor) => UserEntity.fromModel(contributor)).toList(),
        contributors: contributors.map((contributor) => contributor.toEntity()).toList(),
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
  int get hashCode => id!;
}
