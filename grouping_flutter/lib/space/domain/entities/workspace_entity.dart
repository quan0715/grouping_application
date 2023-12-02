import 'package:grouping_project/space/data/models/editable_card_model.dart';
import 'package:grouping_project/space/data/models/image_model.dart';
import 'package:grouping_project/space/data/models/workspace_tag_model.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';


class WorkspaceEntity {
  final int? id;
  final int themeColor;
  final String name;
  final String description;
  final ImageModel? photo;
  final List<int> memberIds;
  // late final List<AccountModel> members;
  late final List<UserEntity> members;
  final List<EditableCardModel> contributingActivities;
  final List<WorkspaceTag> tags;
  final bool isPersonal;

  WorkspaceEntity(
      {required this.id,
      required this.themeColor,
      required this.name,
      required this.description,
      required this.photo,
      required this.memberIds,
      required this.contributingActivities,
      required this.tags,
      required this.isPersonal});
}
