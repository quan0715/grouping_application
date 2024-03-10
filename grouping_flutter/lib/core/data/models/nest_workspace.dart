import 'package:grouping_project/core/data/models/image_model.dart';

/// ## [NestWorkspace] 為巢狀迴圈資料的 workspace
///
/// [NestWorkspace] 擁有 workspace 的 [id], [name], [themecolor] 以及他所對應的 [photo] \
/// 目前此 class 理應此被分別用於 [Activity], [user] 的 [model], [entity] 以及 [MissionState]
class NestWorkspace {
  final int id;
  int themeColor;
  String name;
  ImageModel? photo;

  NestWorkspace(
      {required this.id,
      required this.themeColor,
      required this.name,
      this.photo});

  factory NestWorkspace.fromJson({required Map<String, dynamic> data}) =>
      NestWorkspace(
        id: data["id"],
        themeColor: data["theme_color"],
        name: data["workspace_name"],
        photo: data['photo'] != null
            ? ImageModel.fromJson(data['photo'] as Map<String, dynamic>)
            : null,
      );

  @override
  String toString() {
    return {"id": id, "theme color": themeColor, "name": name}.toString();
  }
}
