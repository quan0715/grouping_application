import 'package:grouping_project/core/data/models/image_model.dart';

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
          photo: data["photo"] != null
              ? ImageModel.fromJson(data["photo"])
              : null);
}
