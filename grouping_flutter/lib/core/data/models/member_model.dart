import 'package:grouping_project/core/data/models/image_model.dart';

class Member {
  final int id;
  final String userName;
  ImageModel? photo;

  Member({
    required this.id,
    required this.userName,
    this.photo,
  });

  factory Member.fromJson({required Map<String, dynamic> data}) => Member(
      id: data['id'],
      userName: data['user_name'],
      photo: data['photo'] != null ? ImageModel.fromJson(data['photo']) : null);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'user_name': userName,
        'photo': photo,
      };

  @override
  String toString() {
    return "id: $id, userName: $userName\n";
  }
}
