import 'package:grouping_project/dashboard/data/models/account_model.dart';
import 'package:grouping_project/dashboard/data/models/photo_model.dart';
import 'package:grouping_project/dashboard/data/models/workspace_tag_model.dart';


class WorkspaceEntity {
  final int? id;
  final int themeColor;
  final String name;
  final String description;
  final Photo? photo;
  final List<String> memberIds;   // TODO: entity should get the name and photo of member instead of memberId
  late final List<AccountModel> members;
  final List<WorkspaceTag> tags;

  WorkspaceEntity(
      {required this.id,
      required this.themeColor,
      required this.name,
      required this.description,
      required this.photo,
      required this.memberIds,
      required this.tags});
}
