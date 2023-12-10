import 'package:grouping_project/space/domain/entities/activity_entity.dart';

class EventEntity extends ActivityEntity{
  DateTime startTime;
  DateTime endTime;
  List<String> relatedMissionIds;

  EventEntity(
      {required super.id,
      required super.title,
      required super.introduction,
      required super.contributors,
      required super.notifications,
      required this.startTime,
      required this.endTime,
      required this.relatedMissionIds,
      super.creatorAccount,
      super.creator});
}
