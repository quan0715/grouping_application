// ignore_for_file: unnecessary_this
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';

// import 'account_model.dart';

/// ## a data model for event
/// * to upload/download, use `DataController`
class EventModel extends ActivityModel {
  // String title;
  DateTime startTime;
  DateTime endTime;
  // List<String> contributorIds;
  // String introduction;
  // List<String> tags;
  // List<DateTime> notifications;
  List<String> relatedMissionIds;
  // AccountModel ownerAccount;

  static final EventModel defaultEvent = EventModel._default();

  EventModel._default()
      : this.startTime = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
        this.endTime = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
        this.relatedMissionIds = [],
        super(
          title: 'unknown',
          contributors: [],
          introduction: 'unknown',
          notifications: [],
          creatorAccount: UserModel.defaultAccount,
          id: 0,
        );

  /// ## a data model for event
  /// * to upload/download, use `DataController`
  EventModel(
      {super.id,
      String? title,
      DateTime? startTime,
      DateTime? endTime,
      List<int>? contributors,
      String? introduction,
      UserModel? creatorAccount,
      List<String>? relatedMissionIds,
      List<DateTime>? notifications})
      : this.startTime = startTime ?? defaultEvent.startTime,
        this.endTime = endTime ?? defaultEvent.endTime,
        this.relatedMissionIds =
            relatedMissionIds ?? List.from(defaultEvent.relatedMissionIds),
        super(
          title: title ?? defaultEvent.title,
          contributors: contributors ?? List.from(defaultEvent.contributors),
          introduction: introduction ?? defaultEvent.introduction,
          notifications: notifications ?? List.from(defaultEvent.notifications),
          creatorAccount: creatorAccount ?? defaultEvent.creatorAccount,
        );

  factory EventModel.fromJson({required Map<String, dynamic> data}) =>
      EventModel(
          id: data['id'] as int,
          title: data['title'] as String,
          introduction: data['description'] as String,
          startTime: DateTime.parse(data['event']['start_time']),
          endTime: DateTime.parse(data['event']['end_time']),
          contributors: data['contributors'].cast<int>() as List<int>,
          // tags: data['tags'].cast<String>() as List<String>,
          relatedMissionIds: data['children'].cast<String>() as List<String>,
          notifications: _notificationFromJson(
              data['notifications'].cast<Map<String, String>>()));

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'title': this.title,
        'description': this.introduction,
        'creator': this.creatorAccount.id,
        'event': {
          'start_time': this.startTime.toIso8601String(),
          'end_time': this.endTime.toIso8601String(),
        },
        'contributors': this.contributors,
        // 'tags': this.tags,
        'children': this.relatedMissionIds,
        'notifications': _notificationsToJson()
      };

  @override
  EventEntity toEntity() {
    return EventEntity(
        id: id,
        title: title,
        introduction: introduction,
        contributors: contributors,
        notifications: notifications,
        creatorAccount: creatorAccount,
        startTime: startTime,
        endTime: endTime,
        relatedMissionIds: relatedMissionIds);
  }

  factory EventModel.fromEntity(EventEntity entity){
    return EventModel(
      id: entity.id,
      title: entity.title,
      introduction: entity.introduction,
      contributors: entity.contributors,
      notifications: entity.notifications,
      creatorAccount: entity.creatorAccount,
      startTime: entity.startTime,
      endTime: entity.endTime,
      relatedMissionIds: entity.relatedMissionIds,
    );
  }

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

  /// TODO: set the data about owner for this instance
  // void setOwner({required AccountModel ownerAccount}) {
  //   this.ownerAccount = ownerAccount;
  // }

  @override
  String toString() {
    return {
      "id": this.id,
      "title": this.title,
      "introduction": this.introduction,
      "startTime": this.startTime,
      "endTime": this.endTime,
      "contributors": this.contributors,
      "notifications": this.notifications,
      "relatedMissionIds": this.relatedMissionIds,
      // "tags": this.tags
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
