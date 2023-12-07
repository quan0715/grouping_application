import 'package:grouping_project/space/data/models/workspace_model_lib.dart';
import 'package:grouping_project/space/domain/entities/editable_card_entity.dart';

class MissionEntity extends EditableCardEntity{
  final DateTime deadline;
  final String stateId;
  final MissionStateModel state;
  final List<String> parentMissionIds;
  final List<String> childMissionIds;

  MissionEntity(
      {required super.id,
      required super.title,
      required super.introduction,
      required super.contributors,
      required super.notifications,
      required super.creatorAccount,
      required this.deadline,
      required this.stateId,
      required this.state,
      required this.parentMissionIds,
      required this.childMissionIds});
}
