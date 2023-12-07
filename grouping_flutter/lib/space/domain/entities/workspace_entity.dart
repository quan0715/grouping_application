import 'package:grouping_project/space/data/models/editable_card_model.dart';
import 'package:grouping_project/core/data/models/image_model.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
// import 'package:grouping_project/space/domain/entities/user_entity.dart';


class WorkspaceEntity {
  final int? id;
  final int themeColor;
  final String name;
  final String description;
  final ImageModel? photo;
  // final List<int> memberIds;
  final List<Member> members;
  final List<EditableCardModel> contributingActivities;
  final List<String> tags;

  WorkspaceEntity(
      {required this.id,
      required this.themeColor,
      required this.name,
      required this.description,
      required this.photo,
      required this.members,
      required this.contributingActivities,
      required this.tags});
}
