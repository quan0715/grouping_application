import 'package:grouping_project/space/domain/entities/editable_card_entity.dart';

class EventEntity extends EditableCardEntity{
  final DateTime startTime;
  final DateTime endTime;
  final List<String> relatedMissionIds;

  EventEntity(
      {required super.id,
      required super.title,
      required super.introduction,
      required super.contributors,
      required super.notifications,
      required super.creatorAccount,
      required this.startTime,
      required this.endTime,
      required this.relatedMissionIds});
}
