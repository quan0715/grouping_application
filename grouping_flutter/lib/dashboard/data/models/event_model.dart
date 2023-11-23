// ignore_for_file: unnecessary_this
import 'package:grouping_project/dashboard/data/models/account_model.dart';
import 'package:grouping_project/dashboard/data/models/editable_card_model.dart';

// import 'account_model.dart';

/// ## a data model for event
/// * to upload/download, use `DataController`
class EventModel extends EditableCardModel {
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
        // this.contributorIds = [],
        // this.introduction = 'unknown',
        // this.tags = [],
        this.relatedMissionIds = [],
        // this.notifications = [],
        // this.ownerAccount = AccountModel.defaultAccount,
        super(
          title: 'unknown',
          contributors: [],
          introduction: 'unknown',
          // tags: [],
          notifications: [],
          creatorAccount: AccountModel.defaultAccount,
          id: 0,
          // databasePath: 'event',
          // storageRequired: false,
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
      // List<String>? tags,
      AccountModel? creatorAccount,
      List<String>? relatedMissionIds,
      List<DateTime>? notifications})
      : this.startTime = startTime ?? defaultEvent.startTime,
        this.endTime = endTime ?? defaultEvent.endTime,
        // this.contributorIds =
        //     contributorIds ?? List.from(defaultEvent.contributorIds),
        // this.introduction = introduction ?? defaultEvent.introduction,
        // this.tags = tags ?? List.from(defaultEvent.tags),
        this.relatedMissionIds =
            relatedMissionIds ?? List.from(defaultEvent.relatedMissionIds),
        // this.notifications =
        //     notifications ?? List.from(defaultEvent.notifications),
        // this.ownerAccount = defaultEvent.ownerAccount,
        super(
          title: title ?? defaultEvent.title,
          contributors:
              contributors ?? List.from(defaultEvent.contributors),
          introduction: introduction ?? defaultEvent.introduction,
          // tags: tags ?? List.from(defaultEvent.tags),
          notifications: notifications ?? List.from(defaultEvent.notifications),
          creatorAccount: creatorAccount ?? defaultEvent.creatorAccount,
          // databasePath: defaultEvent.databasePath,
          // storageRequired: defaultEvent.storageRequired,
          // setOwnerRequired: true
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
          relatedMissionIds:
              data['children'].cast<String>() as List<String>,
          notifications:
              _notificationFromJson(data['notifications'].cast<Map<String, String>>()));

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

  List<Map<String, String>> _notificationsToJson(){
    List<Map<String, String>> notiMap = [];
    for(DateTime noti in this.notifications){
      notiMap.add({"notify_time": noti.toIso8601String()});
    }
    return notiMap;
  }

  static List<DateTime> _notificationFromJson(List<Map<String, String>> data){
    List<DateTime> noti = [];
    for(Map<String, String> object in data){
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
